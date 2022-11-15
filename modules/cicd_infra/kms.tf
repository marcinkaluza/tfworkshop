#
# Encryption key for the artifacts
#
module "artifacts_key" {
  source      = "../kms"
  alias       = "cicd/${var.repo_name}"
  description = "KMS key for the CICD pipeline and build(s)"
  roles       = [aws_iam_role.codepipeline-role.arn, aws_iam_role.codebuild-role.arn]
}
