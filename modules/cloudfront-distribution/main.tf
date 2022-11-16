locals {
  #Managed security headers policy. Policy name: SecurityHeadersPolicy / Policy ID: 67f7725c-6f97-4210-82d7-5512b31e9d03
  security_headers_policy = "67f7725c-6f97-4210-82d7-5512b31e9d03"
}


#
# Configuring Origin Access Identity on S3 Bucket
#
data "aws_iam_policy_document" "access_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.website_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

#
# S3 bucket for CloudFront distribution
#
module "website_bucket" {
  source      = "../s3_bucket"
  name_prefix = var.s3_bucket_prefix
  #Encryption must be AES256 for CloudFront distribution (cf. README)
  sse_algorithm = "AES256"
  access_policy = data.aws_iam_policy_document.access_policy.json
}

#
# S3 bucket for CloudFront logs
#? Add var.s3_bucket_prefix to the name_prefix of the log bucket?
module "access_log_bucket" {
  source      = "../s3_bucket"
  name_prefix = "cf-access-log-"
}

#
# Origin Access Identity for Cloudfront Distribution
#
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = module.website_bucket.name
}

#
# CloudFront Distribution
#
resource "aws_cloudfront_distribution" "distribution" {
  #checkov:skip=CKV2_AWS_32: "Ensure CloudFront distribution has a strict security headers policy attached" <- False positive
  logging_config {
    bucket = module.access_log_bucket.regional_domain_name
  }

  #S3 bucket origin
  origin {
    domain_name = module.website_bucket.regional_domain_name
    origin_id   = var.s3_bucket_prefix

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  #Optional API GW origin only if apigw_origin_enabled is set to true
  dynamic "origin" {
    for_each = var.apigw_origin_enabled[*]
    content {
      domain_name = var.api_domain_name
      origin_id   = var.api_origin_id

      custom_origin_config {
        origin_protocol_policy = "https-only"
        http_port              = "80"
        https_port             = "443"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "my-cloudfront"
  default_root_object = "index.html"

  aliases = var.cloudfront_alias == null ? [] : [var.cloudfront_alias]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket_prefix
    # Managed Security Headers Policy 
    response_headers_policy_id = local.security_headers_policy
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Optional cache behavior with precedence 0
  dynamic "ordered_cache_behavior" {
    for_each = var.apigw_origin_enabled[*]
    content {
      path_pattern     = "/api/*"
      target_origin_id = var.api_origin_id
      allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods   = ["GET", "HEAD"]

      forwarded_values {
        query_string = true
        headers      = ["Accept", "Authorization", "Origin", "Referer", "Content-Type"]

        cookies {
          forward = "none"
        }
      }
      min_ttl     = 0
      default_ttl = 0
      max_ttl     = 0

      compress               = true
      viewer_protocol_policy = "https-only"

      # Managed Security Headers Policy 
      response_headers_policy_id = local.security_headers_policy
    }
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IN", "IE", "FR"]
    }
  }

  #?Import from variables?*
  tags = {
    Environment = "Development"
    Name        = "terraform-reusable-assets"
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  web_acl_id = var.web_acl_id
}

#
# DNS Record for the website
#
resource "aws_route53_record" "root_domain" {
  #checkov:skip=CKV2_AWS_23: A record has attached resources
  count   = var.cloudfront_alias == null ? 0 : 1
  zone_id = var.r53_zone_id
  name    = var.cloudfront_alias
  type    = "A"

  alias {
    name                   = resource.aws_cloudfront_distribution.distribution.domain_name
    zone_id                = resource.aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}