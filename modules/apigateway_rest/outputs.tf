output "rest_api_id" {
  value = resource.aws_api_gateway_rest_api.api.id
}

output "execution_arn" {
  value = resource.aws_api_gateway_rest_api.api.execution_arn
}