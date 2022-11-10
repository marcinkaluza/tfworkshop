

#
# Artifacts bucket
#
module "pipeline_bucket" {
  source      = "../s3_bucket"
  name_prefix = "${var.repo_name}-pipeline-"
}

#
# Code pipeline
#
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.repo_name}"
  role_arn = aws_iam_role.codepipeline-role.arn

  artifact_store {
    location = module.pipeline_bucket.name
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.artifacts_key.arn
      type = "KMS"
    }
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
        RepositoryName       = var.repo_name
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
        ProjectName = module.security-build.project_name
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
        ProjectName = module.infra-build.project_name
        EnvironmentVariables = jsonencode([
          {
            name  = "AWS_ACCOUNT_ID"
            value = "${data.aws_caller_identity.current.id}"
          },
          {
            name  = "TERRAFORM_ROLE"
            value = aws_iam_role.terraform-role.arn
          }
        ])
      }
    }
  }

}

#
# EventBridge rule to trigger cicd pipeline
#
module "trigger" {
  source           = "../cicd_eventbridge_trigger"
  repo_arn         = aws_codecommit_repository.infra_repo.arn
  codepipeline_arn = aws_codepipeline.codepipeline.arn
  rule_name_prefix = "${aws_codepipeline.codepipeline.name}_trigger_"
}