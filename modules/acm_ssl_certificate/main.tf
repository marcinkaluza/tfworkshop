#
# SSL Certificate in US_EAST_1
#
resource "aws_acm_certificate" "ssl_certificate" {
  #Certificate must be in us_east_1 for cloudfront distribution
  provider          = aws.us_east
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    #New ACM certificate must be created before destroying the old one
    create_before_destroy = true
  }
}

#
# R53 records for the SSL Certificate
#
resource "aws_route53_record" "ssl-certificate" {
  provider = aws.local
  #Adressing all domain validation options
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.r53_zone_id
}

#
# ACM Certificate validation for the SSL certificate
#
resource "aws_acm_certificate_validation" "ssl-certificate" {
  #Certificate valdiation must be in us_east_1 for cloudfront distribution
  provider                = aws.us_east
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.ssl-certificate : record.fqdn]
}
