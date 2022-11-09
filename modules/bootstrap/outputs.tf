output "s3_bucket" {
  description = "Bucket for state storage"
  value       = module.bootstrap.state_bucket
}