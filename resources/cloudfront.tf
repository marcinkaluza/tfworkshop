### WEBSITE ###

#
# Cert for the CF distribution
#
module "website-cert" {
  r53_zone_id     = data.aws_route53_zone.domain.zone_id
  domain_name = local.web_domain
  source      = "../modules/acm_ssl_certificate"
  providers = {
    # By default, the child module would use the
    # default (unaliased) AWS provider configuration
    # using us-west-1, but this will override it
    # to use the additional "east" configuration
    # for its resources instead.
    aws.us_east = aws.us_east
    aws.local   = aws
  }
}

module "cloudfront"{
  source = "../modules/cloudfront_distribution"
  acm_certificate_arn  = module.website-cert.acm_certificate_arn
  s3_bucket_prefix     = "reusable-asset-site"
  cloudfront_alias     = local.web_domain
  r53_zone_id          = data.aws_route53_zone.domain.zone_id
  apigw_origin_enabled = true
  api_domain_name      = local.api_domain_name
  api_origin_id        = "API"
  #web_acl_id           = resource.aws_wafv2_web_acl.waf_web_acl_cloudfront.arn
}