output "password" {
  value       = random_password.master_password.result
  description = "Master DB password"
  sensitive   = true
}