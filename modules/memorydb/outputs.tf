#
# Create outputs here
#
output "endpoints" {
  description = "Address of the cluster's endpoint"
  value       = aws_memorydb_cluster.cluster.cluster_endpoint
}
