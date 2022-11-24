data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

#
# Encryption key
#

module key {
  source = "../kms"
  description = "KMS key for the ${var.project_name} CodeBuild project"
  alias = "codebuild/${var.project_name}"
  services = ["codebuild.${data.aws_region.current.name}.amazonaws.com"]
}

