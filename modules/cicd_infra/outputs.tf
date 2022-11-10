output "git_repo_url" {
  value = aws_codecommit_repository.infra_repo.clone_url_http
}

output "terraform_role" {
  value = aws_iam_role.terraform-role.arn
}

output "git_user_name" {
  value = aws_iam_service_specific_credential.code_commit.service_user_name
}

output "git_password" {
  value     = aws_iam_service_specific_credential.code_commit.service_password
  sensitive = true
}

output terraform_state_bucket {
  value       = module.tf_bucket.name
  description = "Name of terraform state bucket"
}

output terraform_lock_table {
  value       = aws_dynamodb_table.locks.name
  description = "Name of terraform lock table"
}
