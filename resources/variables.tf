variable "target_region" {
  type        = string
  description = "Target AWS region for deployment"
}

variable "ami_id" {
  type    = string
  default = null
}
