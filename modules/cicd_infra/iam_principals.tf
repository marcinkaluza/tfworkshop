#
# Role for infra project code build
#
resource "aws_iam_role" "codebuild-role" {
  name = "InfraCodeBuildRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

#
# Role for infra pipeline
#
resource "aws_iam_role" "codepipeline-role" {
  name = "InfraCodePipelineRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

#
# Role for terraform - this will be assumed by code build role during deployment process
#
resource "aws_iam_role" "terraform-role" {
  name = "Terraform-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_role.codebuild-role.arn
        }
      },
    ]
  })
}

#
# IAM policy from the policy.json file attached to the role
#
resource "aws_iam_role_policy" "terraform-policy" {
  name = "Terraform_policy"
  role = aws_iam_role.terraform-role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("${path.module}/policy.json")
}

