variable "acm_certificate_arn" {
  type = string
}

variable "s3_bucket_prefix" {
  type = string
}

variable "cloudfront_alias" {
  type    = string
  default = null
}

variable "r53_zone_id" {
  type        = string
  description = "R53 DNS zone id"
}

variable "apigw_origin_enabled" {
  type        = bool
  description = "Optional addition of apigw origin for cloudfront distribution"
  default     = null
}

variable "api_domain_name" {
  type        = string
  description = "api domain name for cloudfront origin"
  default     = null
}

variable "api_origin_id" {
  type        = string
  description = "api origin id for cloudfront origin"
  default     = null
}

variable "web_acl_id" {
  type        = string
  description = "Web ACL id to associate to cloudfront"
  default     = null
}