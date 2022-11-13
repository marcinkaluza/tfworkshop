#
# Policy allowing deployment of the lambda function
#
data "aws_iam_policy_document" "lambda_access" {
  statement {
    resources = [var.function_arn]
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:PublishVersion",
      "lambda:GetFunction",
    "lambda:UpdateAlias"]
    effect = "Allow"
  }
}

resource "aws_iam_role_policy" "lambda_access" {
  role   = aws_iam_role.codebuild_role.name
  policy = data.aws_iam_policy_document.lambda_access.json
}

resource "aws_iam_policy" "s3_artifacts_policy" {
  name_prefix = "artifacts_bucket_policy_"
  description = "Policy to access the S3 bucket artifacts"

  policy = jsonencode(
    {
      Version : "2012-10-17"
      Statement : [
        {
          Resource : [
            "${module.pipeline_bucket.arn}",
            "${module.pipeline_bucket.arn}/*"
          ]
          Action : [
            "s3:Get*",
            "s3:List*",
          "s3:Put*"]
          Effect : "Allow"
        },
        {
          Resource : [
            "${module.code_bucket.arn}",
            "${module.code_bucket.arn}/*"
          ]
          Action : [
            "s3:Get*",
            "s3:List*",
            "s3:Put*"
          ]
          Effect : "Allow"
        }
      ]
  })
}

resource "aws_iam_policy" "codecommit_policy" {
  name_prefix = "codecommit_repo_policy_"
  description = "Policy to access the infra codecommit repo"

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Resource = ["${aws_codecommit_repository.repo.arn}"]
          Action   = ["codecommit:*"]
          Effect   = "Allow"
        }
      ]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild_policy"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Resource = [
            module.lambda_build.project_name,
            module.lambda_deployment.project_name
          ],
          Action = ["codebuild:*"]
          Effect = "Allow"
        }
      ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  name = "logs_policy"
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Resource = ["*"]
          Action   = ["logs:*"]
          Effect   = "Allow"
        }
      ]
  })
}


#
resource "aws_iam_role_policy_attachment" "cp_attach_policy_cc" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.s3_artifacts_policy.arn
}

resource "aws_iam_role_policy_attachment" "cb_attach_policy_cc" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.s3_artifacts_policy.arn
}

resource "aws_iam_role_policy_attachment" "cp_attach_policy_s3" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codecommit_policy.arn
}

resource "aws_iam_role_policy_attachment" "cb_attach_policy_s3" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codecommit_policy.arn
}
####

data "aws_iam_policy" "codebuild_dev_policy" {
  arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

data "aws_iam_policy" "codepipeline_full_policy" {
  arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}

resource "aws_iam_role_policy_attachment" "cb_attach_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = data.aws_iam_policy.codebuild_dev_policy.arn
}

resource "aws_iam_role_policy_attachment" "cp_attach_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = data.aws_iam_policy.codepipeline_full_policy.arn
}


