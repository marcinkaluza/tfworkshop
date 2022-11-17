variable "api_id" {
  type        = string
  description = "ID of the REST API"
}

variable "stage_name" {
  type        = string
  description = "Name of the styage to be created"
}

variable "deployment_trigger" {
  type        = string
  description = "Variable containing deployment trigger"
}