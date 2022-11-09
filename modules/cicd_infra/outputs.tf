output "infra_git_repo_url" {
  value = module.infra-cc.codecommit_repo_url
}

output "terraform_role" {
  value = aws_iam_role.terraform-role.arn
}

output git_user_name {
  value = aws_iam_service_specific_credential.code_commit.service_user_name
}

output git_password {
  value = aws_iam_service_specific_credential.code_commit.service_password
  sensitive = true
}