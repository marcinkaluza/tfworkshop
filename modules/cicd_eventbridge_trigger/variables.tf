variable "repo_arn" {
  description = "ARN of the CodeCommit repository"
  type        = string
}

variable "codepipeline_arn" {
  description = "ARN of the CodePipeline to be executed on commit"
  type        = string
}

variable "rule_name_prefix" {
  description = "Prefix of the event bridge rule name"
  type        = string
}

variable "branch_name" {
  description = "Name of the code branch to be monitored for changes"
  type        = string
  default     = "main"
}