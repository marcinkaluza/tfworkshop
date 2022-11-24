#
# Route53 Hosted Zone
# 
# resource "aws_route53_zone" "dev" {
#   name         = "reusable-tf-assets.com"
# }

resource "aws_iam_role" "test_role" {
  name_prefix = "test_role_"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

module "sample" {
  source      = "../modules/s3_bucket"
  name_prefix = "test-bucket-"
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      module.sample.arn
    ]
  }
}

module "lambda" {
  source          = "../modules/lambda"
  function_name   = "test"
  handler_name    = "app.lambda_handler"
  description     = "Test function"
  resource_policy = data.aws_iam_policy_document.lambda_policy.json
}

module "lambda_pipeline" {
  source        = "../modules/cicd_lambda"
  function_name = "test"
  function_arn  = module.lambda.arn
}

data "aws_caller_identity" "current" {}

module "kms" {
  source      = "../modules/kms"
  alias       = "cmk/Test"
  description = "Test KMS key"
  roles       = [aws_iam_role.test_role.arn]
}

module "api_logging" {
  source = "../modules/apigateway_logging"
}

module "api" {
  source   = "../modules/apigateway_rest"
  api_name = "Test-API"
  api_spec = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "Partner platform API"
      version = "1.0"
    },
    paths = {
      "/api/hello" = {
        get = {
          produces = ["application/json"]
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "1.0"
            type                 = "AWS_PROXY"
            uri                  = "arn:aws:apigateway:${var.target_region}:lambda:path/2015-03-31/functions/${module.lambda.arn}:$${stageVariables.lambdaAlias}/invocations"
          }
        }
      }
      "/api/mock" = {
        get = {
          responses = {
            "200" = {
              "description" = "200 response",
              "content"     = {}
            }
          }
          x-amazon-apigateway-integration = {
            responses = {
              "2\\d{2}" = {
                statusCode = "200",
                responseTemplates = {
                  "application/json" = "{ \"someCode\": 200\n }"
                }
              }
            },
            requestTemplates = {
              "application/json" = "{\n   \"statusCode\": 200\n}"
            },
            passthroughBehavior = "never"
            type                = "mock"
          }
        }
      }
    }
    components = {
      # securitySchemes = {
      #   Lambda = {
      #     type                         = "apiKey"
      #     name                         = "Authorization"
      #     in                           = "header"
      #     x-amazon-apigateway-authtype = "custom"
      #     x-amazon-apigateway-authorizer = {
      #       authorizerUri                = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/${module.authorizer.lambda_arn}/invocations"
      #       authorizerCredentials        = aws_iam_role.apigw_authorizer_role.arn
      #       authorizerResultTtlInSeconds = 300
      #       identitySource               = "method.request.header.Authorization"
      #       type                         = "request"
      #     }
      #   }
      # }
    }
  })
}
#
# Since we are using lambda sas the API backend, we need to grant permissions 
# for the API gateweay to invoke lambda
#
resource "aws_lambda_permission" "prod_alias_access" {
  for_each      = toset(["prod", "test"])
  statement_id  = "API"
  action        = "lambda:InvokeFunction"
  function_name = "test"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api.execution_arn}/*/*/*"
  qualifier     = each.key
}

module "vpc" {
  source                      = "../modules/vpc"
  name                        = "Main VPC"
  cidr_block                  = "10.0.0.0/16"
  public_subnets_cidr_blocks  = ["10.0.1.0/24", "10.0.3.0/24"]
  private_subnets_cidr_blocks = ["10.0.2.0/24", "10.0.4.0/24"]
  interface_endpoint_services = ["ec2", "logs"]
  gateway_endpoint_services   = ["s3"]
}

module "vpc2" {
  source                      = "../modules/vpc"
  name                        = "Second VPC"
  cidr_block                  = "10.0.0.0/16"
  public_subnets_cidr_blocks  = ["10.0.1.0/24"]
  private_subnets_cidr_blocks = ["10.0.2.0/24"]
  allow_internet_egress       = false
  interface_endpoint_services = ["ec2", "logs"]
}


module "secret" {
  source        = "../modules/secretsmanager_secret"
  name          = "test_secret_1"
  secret_string = "Pa$$w0rd"
  roles         = [aws_iam_role.test_role.arn, data.aws_caller_identity.current.arn]
}