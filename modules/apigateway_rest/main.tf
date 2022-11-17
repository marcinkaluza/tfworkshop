
locals {
  stages = ["prod", "test"]
}

#
# API Gateway API
#
resource "aws_api_gateway_rest_api" "api" {
  body = var.api_spec
  name = var.api_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

#
# Stage(s)
#
module "stage" {
  for_each           = toset(local.stages)
  source             = "./stage"
  api_id             = aws_api_gateway_rest_api.api.id
  stage_name         = each.key
  deployment_trigger = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
}






