output "acm_certificate_arn" {
  value       = resource.aws_acm_certificate.ssl_certificate.arn
  description = "ARN of acm certificate"
}