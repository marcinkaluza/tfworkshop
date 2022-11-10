#
# Security checks using checkov
#
module "security-build" {
  source              = "../codebuild"
  codecommit_repo     = var.repo_name
  codebuild_role      = aws_iam_role.codebuild-role.arn
  buildspec_file_name = "buildspec-sec.yml"
  project_name        = "security-review"
}

#
# Infra deployment build
#
module "infra-build" {
  source              = "../codebuild"
  codecommit_repo     = var.repo_name
  codebuild_role      = aws_iam_role.codebuild-role.arn
  buildspec_file_name = "buildspec.yml"
  project_name        = "infrastructure-build"
}



