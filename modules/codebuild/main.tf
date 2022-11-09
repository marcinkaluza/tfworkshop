data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_kms_key" "codebuild_kms" {
  description             = "${var.project_name}-kmskey"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_policy.json
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid       = "1"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.id}:root"]
    }
  }
  statement {
    sid    = "2"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.${data.aws_region.current.name}.amazonaws.com"]
    }
  }
}

resource "aws_codebuild_project" "build_project" {
  build_timeout  = 60
  name           = var.project_name
  service_role   = var.codebuild_role
  encryption_key = aws_kms_key.codebuild_kms.arn

  environment {
    compute_type                = var.compute_type
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = "${var.project_name}-log-group"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec = var.file
    location  = var.codecommit_repo
    type      = "CODECOMMIT"
  }


}

output "project_name" {
  value = aws_codebuild_project.build_project.id
}
