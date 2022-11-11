module "sample" {
  source      = "../modules/s3_bucket"
  name_prefix = "dummy-"
}

module "lambda" {
  source = "../modules/lambda"
  function_name = "test"
  handler_name  = "app.handler"
  description   = "Test function"
  resource_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Action   = ["s3:Get*"]
      Effect   = "Allow"
      Resource = [module.sample.arn]
    }
  })
} 