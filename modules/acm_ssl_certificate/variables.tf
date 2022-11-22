variable "r53_zone_id" {
  type = string
  description = "Hosted Zone ID for a CloudFront distribution."
}

variable "domain_name" {
  type = string
  description = "Domain name for which the certificate should be issued"
}