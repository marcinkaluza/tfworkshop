# What is this module for?
This module creates following resources:
* Amazon Memory DB cluster
* Subnet group
* Memory DB user account and acl


# How do I use it?
Simple useage:

```hcl
module "memory_db" {
  source             = "../modules/memorydb"
  subnet_ids         = module.vpc.vpc_private_subnet_ids
  user_name          = "master"
  password           = random_password.memdb_password.result
  cluster_name       = "memory-db"
  security_group_ids = [aws_security_group.memorydb.id]
  kms_key_arn        = module.kms.arn
}
```
# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|user_name|Yes|Name of the user account to create|
|password|Yes|Password for the user account|
|cluster_name|Yes|Name of the Memory DB cluster|
|subnet_ids|Yes|List of subnets where the cluster nodes will be created|
|security_group_ids|Yes|List of one or more security groups to control traffic to the cluster|
|kms_key_arn|Yes|ARN of the encryption key to be used to encrypt data at rest|
|num_shards|No|Number of shards. Defaults to 1|
|node_type|No|Type fo the cluster node instance. Defaults to db.t4g.small|

# Outputs
|Output|Description|
|---|---|
|cluster_endpoints|List of cluster endpoints|

# Ignored checkov warnings

None
