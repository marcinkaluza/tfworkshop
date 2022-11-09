#S3 bucket ARN for the codepipeline artifact store
output "s3_arn" {
  value = aws_s3_bucket.codepipeline_bucket.arn
}

#CodePipeline ARN
output "infra_codepipeline_arn" {
  value = aws_codepipeline.codepipeline.arn
}
