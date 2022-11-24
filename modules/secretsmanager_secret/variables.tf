#
# Module's input variables
#
variable "name" {
  description = "Name of the secret"
  type        = string
}

variable "secret_string" {
  description = "Secret string to be stored inside secret"
  type        = string
}

variable "roles" {
  type        = list(string)
  description = "List of ARN of IAM roles with access to the secret"
}


variable "rotation_lambda_arn" {
  description = "ARN of the lambda function to be used to rotate secret"
  type        = string
  default     = null
}

variable "rotation_interval" {
  type        = number
  description = "Secret rotation interval"
  default     = 7
}



