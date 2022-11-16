# #
# # Custom domain for the api GW
# #
# resource "aws_api_gateway_domain_name" "domain" {
#   domain_name              = var.api_domain_name
#   regional_certificate_arn = aws_acm_certificate_validation.apicert.certificate_arn
#   security_policy          = "TLS_1_2"
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# # Example DNS record using Route53.
# # Route53 is not specifically required; any DNS host can be used.
# resource "aws_route53_record" "dnsentry" {
#   name    = aws_api_gateway_domain_name.domain.domain_name
#   type    = "A"
#   zone_id = var.r53_zone_id

#   alias {
#     evaluate_target_health = true
#     name                   = aws_api_gateway_domain_name.domain.regional_domain_name
#     zone_id                = aws_api_gateway_domain_name.domain.regional_zone_id
#   }
# }

# #
# # Mapping of custom domain to API
# #
# resource "aws_api_gateway_base_path_mapping" "mapping" {
#   api_id      = aws_api_gateway_rest_api.api.id
#   stage_name  = aws_api_gateway_stage.prod.stage_name
#   domain_name = aws_api_gateway_domain_name.domain.domain_name
# }