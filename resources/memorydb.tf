locals {
  memorydb_port = 6379
}

resource "aws_security_group" "memorydb" {
  #checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"  
  name_prefix = "memorydb_security_group_"
  description = "SG for Memory DB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Ingress from VPC CIDR"
    from_port   = local.memorydb_port
    to_port     = local.memorydb_port
    protocol    = "tcp"
    cidr_blocks = [local.cidr_block]
  }
}

resource "random_password" "memdb_password" {
  length = 16
}

module "memory_db" {
  source             = "../modules/memorydb"
  subnet_ids         = module.vpc.vpc_private_subnet_ids
  user_name          = "master"
  password           = random_password.memdb_password.result
  cluster_name       = "memory-db"
  security_group_ids = [aws_security_group.memorydb.id]
  kms_key_arn        = module.kms.arn
}

module "memdb_secret" {
  source        = "../modules/secretsmanager_secret"
  name          = "memdb_secret"
  secret_string = random_password.memdb_password.result
  roles         = [aws_iam_role.test_role.arn, data.aws_caller_identity.current.arn]
}