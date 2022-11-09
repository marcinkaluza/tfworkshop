variable "codecommit_repo" {
  type = string
}

variable "codebuild_role" {
  type = string
}

variable "file" {
  type    = string
  default = "buildspec.yml"
}

variable "project_name" {
  type = string
}

variable "compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"
}

