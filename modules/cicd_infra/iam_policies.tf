resource "aws_iam_policy" "s3_artifacts_policy" {
  name        = "artifacts_bucket_policy"
  description = "Policy to access the S3 bucket artifacts"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Resource": ["${module.infra-pipeline.s3_arn}", "${module.infra-pipeline.s3_arn}/*" ],
      "Action": ["s3:Get*", "s3:List*", "s3:Put*"],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codecommit_policy" {
  name        = "codecommit_repo_policy"
  description = "Policy to access the infra codecommit repo"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Resource": ["${module.infra-cc.repo_arn}", "${module.infra-cc.repo_arn}/*" ],
      "Action": ["codecommit:*"],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild_policy"
  description = "Policy to access the infra codebuild project"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Resource": ["${module.infra-build.project_name}","${module.infra-build.project_name}/*",
      "${module.security-build.project_name}","${module.security-build.project_name}/*"
      ],
      "Action": ["codebuild:*"],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "logs_policy"
  description = "Policy to create cloudwatch logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Resource": ["*" ],
      "Action": ["logs:*"],
      "Effect": "Allow"
    }
  ]
}
EOF
}


data "aws_iam_policy" "codebuild_dev_policy" {
  arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

data "aws_iam_policy" "codepipeline_full_policy" {
  arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}

resource "aws_iam_role_policy_attachment" "cb_attach_policy" {
  role       = aws_iam_role.codebuild-role.name
  policy_arn = data.aws_iam_policy.codebuild_dev_policy.arn
}

resource "aws_iam_role_policy_attachment" "cp_attach_policy" {
  role       = aws_iam_role.codepipeline-role.name
  policy_arn = data.aws_iam_policy.codepipeline_full_policy.arn
}

resource "aws_iam_role_policy_attachment" "cp_attach_policy_cc" {
  role       = aws_iam_role.codepipeline-role.name
  policy_arn = aws_iam_policy.s3_artifacts_policy.arn
}

resource "aws_iam_role_policy_attachment" "cp_attach_policy_s3" {
  role       = aws_iam_role.codepipeline-role.name
  policy_arn = aws_iam_policy.codecommit_policy.arn
}

resource "aws_iam_role_policy_attachment" "cb_attach_policy_cc" {
  role       = aws_iam_role.codebuild-role.name
  policy_arn = aws_iam_policy.s3_artifacts_policy.arn
}

resource "aws_iam_role_policy_attachment" "cb_attach_policy_s3" {
  role       = aws_iam_role.codebuild-role.name
  policy_arn = aws_iam_policy.codecommit_policy.arn
}

resource "aws_iam_role_policy_attachment" "cp_attach_policy_cb" {
  role       = aws_iam_role.codepipeline-role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_role_policy_attachment" "cp_attach_policy_logs" {
  role       = aws_iam_role.codebuild-role.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}

