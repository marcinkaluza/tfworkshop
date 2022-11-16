#
# WAF association
#
# resource "aws_wafv2_web_acl" "apigw" {
#   #checkov:skip=CKV2_AWS_31: no logging configuration
#   name  = "${var.api_name}-apigw-web-acl-association"
#   scope = "REGIONAL"

#   default_action {
#     allow {}
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "friendly-metric-name"
#     sampled_requests_enabled   = true
#   }

#   rule {
#     name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
#     priority = 1

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesKnownBadInputsRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "friendly-rule-metric-name"
#       sampled_requests_enabled   = false
#     }
#   }
# }

# resource "aws_wafv2_web_acl_association" "prod_stage" {
#   resource_arn = aws_api_gateway_stage.prod.arn
#   web_acl_arn  = aws_wafv2_web_acl.apigw.arn
# }

# resource "aws_wafv2_web_acl_association" "test_stage" {
#   resource_arn = aws_api_gateway_stage.test.arn
#   web_acl_arn  = aws_wafv2_web_acl.apigw.arn
# }
