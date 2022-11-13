variable "codebuild_role" {
  description = "ARN of the IAM role to be used by the codebuild"
  type = string
}

variable "buildspec_file_name" {
  description = "Name of the buildspec file"
  type    = string
  default = "buildspec.yml"
}

variable "project_name" {
  description = "Name of the codebuild project"
  type = string
}

variable "compute_type" {
  description = "Type of the compute platform to be used"
  type    = string
  default = "BUILD_GENERAL1_SMALL"
}


