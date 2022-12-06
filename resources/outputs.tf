output "rds_password" {
  value       = random_password.master_password.result
  description = "Master DB password"
  sensitive   = true
}

output "memdb_password" {
  value       = random_password.memdb_password.result
  sensitive   = true
  description = "Memory DB password"
}
