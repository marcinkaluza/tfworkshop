output "repo_arn" {
  value = aws_codecommit_repository.infra-repo.arn
}

output "codecommit_repo_url" {
  value = aws_codecommit_repository.infra-repo.clone_url_http
}