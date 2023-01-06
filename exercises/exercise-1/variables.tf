# Create variable of type string to contain target region 
# https://developer.hashicorp.com/terraform/language/values/variables

variable "target_region" {
  type        = string
  description = "Target region for deployment"
}

