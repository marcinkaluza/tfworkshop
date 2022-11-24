#
# Create outputs here
#
output "arn" {
  description = "ARN of the secret"
  value       = aws_secretsmanager_secret.secret.arn
}