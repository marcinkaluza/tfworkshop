variable "api_name" {
  type        = string
  description = "Name of the API"
}

variable "api_spec" {
  type        = string
  description = "OPEN API Specification of the API"
}

# variable "api_domain_name" {
#   type        = string
#   description = "API custom domain name"
# }

# variable "r53_zone_id" {
#   type        = string
#   description = "R53 zone id"
# }

variable "user_pool_arn" {
  type        = string
  default     = null
  description = "Cognito user pool ARN"
}