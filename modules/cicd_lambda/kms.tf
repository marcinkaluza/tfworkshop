data "aws_region" "current" {}

#
# Encryption key
#
module "artifacts_key" {
  source      = "../kms"
  description = "CICD artifacts encryption key for the ${var.function_name} lambda function pipeline and build(s)"
  roles       = [aws_iam_role.codepipeline_role.arn, aws_iam_role.codebuild_role.arn]
  alias       = "cicd/${var.function_name}"
}




