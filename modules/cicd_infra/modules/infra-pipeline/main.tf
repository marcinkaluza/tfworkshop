data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "codepipeline_bucket" {

  # acl    = "private"
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "aws:kms"
  #     }
  #   }
  # }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.codepipeline_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_codepipeline" "codepipeline" {
  name     = "cicd-infra-pipeline"
  role_arn = var.codepipeline_role

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifacts"]

      configuration = {
        RepositoryName       = var.repo
        BranchName           = "main"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "SecurityScan"

    action {
      name            = "SecurityReview"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifacts"]
      version         = "1"
      run_order       = "1"

      configuration = {
        ProjectName = var.security_project
        EnvironmentVariables = jsonencode([
          {
            name  = "AWS_ACCOUNT_ID"
            value = "${data.aws_caller_identity.current.id}"
          }
        ])
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "BuildInfra"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifacts"]
      version         = "1"
      run_order       = "2"

      configuration = {
        ProjectName = var.infra_project
        EnvironmentVariables = jsonencode([
          {
            name  = "AWS_ACCOUNT_ID"
            value = "${data.aws_caller_identity.current.id}"
          },
          {
            name  = "TERRAFORM_ROLE"
            value = var.terraform_role
          }
        ])
      }
    }
  }

}

