
#
# Code commit repo for IaC terraform config
#
module "infra-cc" {
  #Skipping checkov checks
  #checkov:skip=CKV2_AWS_37: No approval rule on CodeCommit
  source    = "./modules/CodeCommit"
  repo_name = var.repo_name
}

#
# Security checks using checkov
#
module "security-build" {
  source          = "./modules/infra-codebuild"
  codecommit_repo = var.repo_name
  codebuild_role  = aws_iam_role.codebuild-role.arn
  file            = "buildspec-sec.yml"
  project_name    = "security-review"
}

#
# Infra deployment build
#
module "infra-build" {
  source          = "./modules/infra-codebuild"
  codecommit_repo = var.repo_name
  codebuild_role  = aws_iam_role.codebuild-role.arn
  file            = "buildspec.yml"
  project_name    = "infrastructure-build"
}

#
# Pipeline for infra
#
module "infra-pipeline" {
  source            = "./modules/infra-pipeline"
  repo              = var.repo_name
  codepipeline_role = aws_iam_role.codepipeline-role.arn
  security_project  = module.security-build.project_name
  infra_project     = module.infra-build.project_name
  terraform_role    = aws_iam_role.terraform-role.arn
}

#
# EventBridge rule to trigger cicd pipeline
#
# CHANGE VARIABLES 
module "infra-eventbridge" {
  source                 = "./modules/infra-eventbridge"
  infra_repo_arn         = module.infra-cc.repo_arn
  infra_codepipeline_arn = module.infra-pipeline.infra_codepipeline_arn
}

# TODO: create gitlab-user account
#
# User
#
resource "aws_iam_user" "gitlab_user" {
  name = "gitlab-user" # Use this name to avoid pitbull policy violations
  path = "/"
}

#
# Attach code commit access policy to the user
#
resource "aws_iam_user_policy" "accesspolicy" {
  name = "CodeCommit_Access_Policy"
  user = aws_iam_user.gitlab_user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codecommit:BatchGet*",
          "codecommit:BatchDescribe*",
          "codecommit:Describe*",
          "codecommit:EvaluatePullRequestApprovalRules",
          "codecommit:Get*",
          "codecommit:List*",
          "codecommit:Git*"
        ]
        Effect   = "Allow"
        Resource = module.infra-cc.repo_arn
      },
    ]
  })
}

#
# Git credentials
#
resource "aws_iam_service_specific_credential" "code_commit" {
  service_name = "codecommit.amazonaws.com"
  user_name    = aws_iam_user.gitlab_user.name
}