variable "repo" {
  type = string
}

variable "infra_project" {
  type = string
}
variable "security_project" {
  type = string
}

variable "codepipeline_role" {
  type = string
}

variable "terraform_role" {
  type        = string
  description = "ARN of the terraform role to be passed as env variable to build tasks"
}