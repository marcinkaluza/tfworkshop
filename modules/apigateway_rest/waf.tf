#
# WAF association
#
resource "aws_wafv2_web_acl" "acl" {
  #checkov:skip=CKV2_AWS_31: "Ensure WAF2 has a Logging Configuration"
  name  = "${var.api_name}-apigw-web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "all-rules"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "bad-inputs"
      sampled_requests_enabled   = false
    }
  }
}

