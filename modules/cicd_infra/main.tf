
#
# Code commit repo for IaC terraform config
#
resource "aws_codecommit_repository" "infra_repo" {
  repository_name = var.repo_name
  description     = "This is the Infra Repository"
}

#
# Security checks using checkov
#
module "security-build" {
  source          = "../codebuild"
  codecommit_repo = var.repo_name
  codebuild_role  = aws_iam_role.codebuild-role.arn
  file            = "buildspec-sec.yml"
  project_name    = "security-review"
}

#
# Infra deployment build
#
module "infra-build" {
  source          = "../codebuild"
  codecommit_repo = var.repo_name
  codebuild_role  = aws_iam_role.codebuild-role.arn
  file            = "buildspec.yml"
  project_name    = "infrastructure-build"
}

#
# EventBridge rule to trigger cicd pipeline
#
# CHANGE VARIABLES 
module "infra-eventbridge" {
  source                 = "../codepipeline-eventbridge"
  infra_repo_arn         = aws_codecommit_repository.infra_repo.arn
  infra_codepipeline_arn = aws_codepipeline.codepipeline.arn
}

