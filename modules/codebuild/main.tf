#
# Codebuild project
#
resource "aws_codebuild_project" "build_project" {
  build_timeout  = 60
  name           = var.project_name
  service_role   = var.codebuild_role
  encryption_key = aws_kms_key.key.arn

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
    buildspec = var.buildspec_file_name
    location  = var.codecommit_repo
    type      = "CODECOMMIT"
  }
}


