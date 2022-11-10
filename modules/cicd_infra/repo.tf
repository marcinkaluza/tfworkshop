#
# Code commit repo for IaC terraform config
#
resource "aws_codecommit_repository" "infra_repo" {
  #checkov:skip=CKV2_AWS_37: "Ensure Codecommit associates an approval rule"
  repository_name = var.repo_name
  description     = "IaC Repository"
}