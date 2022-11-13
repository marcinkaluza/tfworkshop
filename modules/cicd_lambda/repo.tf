#
# Code commit repo for IaC terraform config
#
resource "aws_codecommit_repository" "repo" {
  #checkov:skip=CKV2_AWS_37: "Ensure Codecommit associates an approval rule"
  repository_name = var.function_name
  description     = "Repository for ${var.function_name} lambda function code."
}