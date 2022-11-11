
#
# IAM role for the lambda function
#
resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.function_name}-Lambda-Role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
          Effect = "Allow"
        }
      ]
  })
}

#
# Attaching AWSLambdaBasicExecutionRole policy to the Lambda role (AWS Managed Policy)
#
resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#
# Resource access policy
#
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "Resource_access_policy"
  role   = aws_iam_role.iam_for_lambda.id
  policy = var.resource_policy
}

#
# Lambda function
#
resource "aws_lambda_function" "function" {
  #Skipping checkov checks
  #checkov:skip=CKV_AWS_116: Don't need SQS Dead Letter Queue

  #checkov:skip=CKV_AWS_173: Encryption for env variables
  #checkov:skip=CKV_AWS_272: Code signing

  function_name = var.function_name
  description   = var.description
  role          = aws_iam_role.iam_for_lambda.arn
  publish       = true # Creates version of the function so we can reference it in an alias
  handler       = var.handler_name
  runtime       = var.runtime
  timeout       = 15
  memory_size   = var.memory_size
  # Just a dummy empty lambda implementation
  filename = "${path.module}/code.zip"

  tracing_config {
    mode = "Active"
  }

  reserved_concurrent_executions = -1
  environment {
    variables = var.environment_variables
  }

  vpc_config {
    # If the list of security group ids and subnets are empty,
    # this property is effectively ignored
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
}

#
# Test alias for the function
#
resource "aws_lambda_alias" "test_alias" {
  name             = "test"
  description      = "Test version of the function"
  function_name    = aws_lambda_function.function.arn
  function_version = aws_lambda_function.function.version

  lifecycle {
    ignore_changes = [
      # Ignore changes to function version as those will be managed by the lambda function build
      function_version
    ]
  }
}

#
# Prod alias for the function
#
resource "aws_lambda_alias" "prod_alias" {
  name             = "prod"
  description      = "Prod version of the function"
  function_name    = aws_lambda_function.function.arn
  function_version = aws_lambda_function.function.version

  lifecycle {
    ignore_changes = [
      # Ignore changes to function version as those will be managed by the lambda function build
      function_version
    ]
  }
}