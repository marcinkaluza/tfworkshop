#
# User account with access to codecommit (no console access or access keys required)
#
resource "aws_iam_user" "gitlab_user" {
  name = "gitlab-user" # Use this name to avoid pitbull policy violations
  path = "/"
}

#
# Attach code commit access policy to the user
#
resource "aws_iam_user_policy" "access_policy" {
  #checkov:skip=CKV_AWS_40: "Ensure IAM policies are attached only to groups or roles (Reducing access management complexity may in-turn reduce opportunity for a principal to inadvertently receive or retain excessive privileges.)"
  name = "CodeCommit_Access_Policy"
  user = aws_iam_user.gitlab_user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codecommit:BatchGet*",
          "codecommit:BatchDescribe*",
          "codecommit:Describe*",
          "codecommit:EvaluatePullRequestApprovalRules",
          "codecommit:Get*",
          "codecommit:List*",
          "codecommit:Git*"
        ]
        Effect   = "Allow"
        Resource = aws_codecommit_repository.infra_repo.arn
      },
    ]
  })
}

#
# Git credentials
#
resource "aws_iam_service_specific_credential" "code_commit" {
  service_name = "codecommit.amazonaws.com"
  user_name    = aws_iam_user.gitlab_user.name
}