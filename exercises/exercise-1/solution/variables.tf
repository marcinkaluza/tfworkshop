# Create variable of type string to contain target region 
# https://developer.hashicorp.com/terraform/language/values/variables

variable "target_region" {
  type        = string
  default     = "us-east-1"
  description = "Target region for deployment"
}

