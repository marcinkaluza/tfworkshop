variable "target_region" {
  type        = string
  description = "Target AWS region for deployment"
}

variable "domain_name" {
  type        = string
  description = "Custom domain name for Cloudfront distribution"
}
variable "ami_id" {
  type    = string
  default = null
}
