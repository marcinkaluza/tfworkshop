#
# S3 Buckets
#
module "pipeline_bucket" {
  source      = "../s3_bucket"
  name_prefix = "${var.function_name}-pipeline-bucket-"
}

module "code_bucket" {
  source      = "../s3_bucket"
  name_prefix = "${var.function_name}-code-bucket-"
}
#
# Code pipeline
#
resource "aws_codepipeline" "codepipeline" {
  #checkov:skip=CKV_AWS_219: no kms cmk on artifact store
  name     = "${var.function_name}-pipeline"
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
    name = "Build"

    action {
      name             = "BuildLambda"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifacts"]
      output_artifacts = ["BuildArtifacts"]
      version          = "1"
      run_order        = "2"

      configuration = {
        ProjectName = module.lambda_build.project_name
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
    name = "Deploy"

    action {
      name            = "DeployLambda"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["BuildArtifacts"]
      version         = "1"
      run_order       = "3"

      configuration = {
        BucketName = module.code_bucket.name
        Extract    = false
        ObjectKey  = "code.zip"
      }
    }
  }

  stage {
    name = "Update"

    action {
      name            = "UpdateLambda"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifacts"]
      version         = "1"
      run_order       = "3"

      configuration = {
        ProjectName = module.lambda_deployment.project_name
      }
    }
  }

}

#
# EventBridge rule to trigger cicd pipeline
#
module "trigger" {
  source           = "../cicd_eventbridge_trigger"
  repo_arn         = aws_codecommit_repository.repo.arn
  codepipeline_arn = aws_codepipeline.codepipeline.arn
  rule_name_prefix = "${aws_codepipeline.codepipeline.name}_trigger_"
}

