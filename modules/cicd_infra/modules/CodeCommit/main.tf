resource "aws_codecommit_repository" "infra-repo" {
  repository_name = var.repo_name
  description     = "This is the Infra Repository"
}

