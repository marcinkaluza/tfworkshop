output "rest_api_id" {
  value = resource.aws_api_gateway_rest_api.api.id
}

# output "rest_api_deployment_id" {
#   value = resource.aws_api_gateway_deployment.prod.id
# }

# output "rest_api_stage_arn" {
#   value = resource.aws_api_gateway_stage.prod.arn
# }

output "execution_arn" {
  value = resource.aws_api_gateway_rest_api.api.execution_arn
}