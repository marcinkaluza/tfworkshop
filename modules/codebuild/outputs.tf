output "id" {
  description = "Codebuild project id"
  value       = resource.aws_codebuild_project.build_project.id
}

output "project_name" {
  description = "Codebuild project name"
  value       = aws_codebuild_project.build_project.id
}