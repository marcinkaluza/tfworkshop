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
  source = "../modules/lambda"
  function_name = "test"
  handler_name  = "app.lambda_handler"
  description   = "Test function"
  resource_policy = data.aws_iam_policy_document.lambda_policy.json
} 

module lambda_pipeline {
    source = "../modules/cicd_lambda"
    function_name = "test"
    function_arn = module.lambda.arn
}

data aws_caller_identity current {}

module kms {
  source = "../modules/kms"
  alias = "cmk/Test"
  description = "Test KMS key"
  roles = [data.aws_caller_identity.current.arn]
}