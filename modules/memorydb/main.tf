locals {
  acl_name = "acl"
}
#
# User account
#
resource "aws_memorydb_user" "user" {
  user_name     = var.user_name
  access_string = "on ~* &* +@all"

  authentication_mode {
    type      = "password"
    passwords = [var.password]
  }
}

#
# ACL for the cluster
#
resource "aws_memorydb_acl" "acl" {
  name       = local.acl_name
  user_names = [aws_memorydb_user.user.id]
}

#
# Subnet group
#
resource "aws_memorydb_subnet_group" "subnet_group" {
  name       = "${var.cluster_name}-subnet-group"
  subnet_ids = var.subnet_ids
}

#
# Cluster
#
resource "aws_memorydb_cluster" "cluster" {
  acl_name                 = local.acl_name
  name                     = var.cluster_name
  node_type                = var.node_type
  num_shards               = var.num_shards
  security_group_ids       = var.security_group_ids
  snapshot_retention_limit = 7
  subnet_group_name        = aws_memorydb_subnet_group.subnet_group.id
  kms_key_arn              = var.kms_key_arn
}