
#
# Deployment of the API
#
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = var.api_id

  triggers = {
    redeployment = var.deployment_trigger
  }

  lifecycle {
    create_before_destroy = true
  }

  variables = {
    lambdaAlias = var.stage_name
  }
}

#
# Cloud watch log groups for execution and access logs
#
resource "aws_cloudwatch_log_group" "execution_logs" {
  name              = "api/${var.api_id}/${var.stage_name}/execution"
  retention_in_days = 7
  kms_key_id        = module.key.arn
  # ... potentially other configuration ...
}

resource "aws_cloudwatch_log_group" "access_logs" {
  name              = "api/${var.api_id}/${var.stage_name}/acccess"
  retention_in_days = 7
  kms_key_id        = module.key.arn
  # ... potentially other configuration ...
}

#
# Stage
#
resource "aws_api_gateway_stage" "stage" {
  depends_on = [aws_cloudwatch_log_group.execution_logs]
  #Skipping checkov checks
  #checkov:skip=CKV_AWS_120: "Ensure API Gateway caching is enabled"
  deployment_id        = aws_api_gateway_deployment.deployment.id
  rest_api_id          = var.api_id
  stage_name           = var.stage_name
  xray_tracing_enabled = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access_logs.arn
    format = jsonencode(
      {
        requestid         = "$context.requestId"
        extendedRequestId = "$context.extendedRequestId"
        ip                = "$context.identity.sourceIp"
        caller            = "$context.identity.caller"
        user              = "$context.identity.user"
        requestTime       = "$context.requestTime"
        httpMethod        = "$context.httpMethod",
        resourcePath      = "$context.resourcePath"
        status            = "$context.status"
        protocol          = "$context.protocol"
        responseLength    = "$context.responseLength"
      }
    )
  }

  variables = {
    lambdaAlias = var.stage_name
  }
}

#
# Enable logging at error level
#
resource "aws_api_gateway_method_settings" "prod" {
  #checkov:skip=CKV_AWS_225: "Ensure API Gateway method setting caching is enabled"
  rest_api_id = var.api_id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
  }
}







