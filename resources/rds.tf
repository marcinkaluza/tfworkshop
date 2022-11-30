resource "aws_security_group" "rds" {
  #checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"  
  name_prefix = "rds_security_group_"
  description = "SG for Rds"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Ingress from VPC CIDR"
    from_port   = local.rds_port
    to_port     = local.rds_port
    protocol    = "tcp"
    cidr_blocks = [local.cidr_block]
  }
}

resource "random_password" "master_password" {
  length = 16
}

module "rds_aurora" {
  source             = "../modules/rds_aurora"
  subnet_ids         = module.vpc.vpc_private_subnet_ids
  database_name      = "aurora_db"
  master_username    = "master"
  master_password    = random_password.master_password.result
  cluster_engine     = "aurora-postgresql"
  cluster_identifier = "aurora"
  instance_class     = "db.t3.medium"
  backup_kms         = module.kms.arn
  port               = local.rds_port
  security_group_ids = [aws_security_group.rds.id]
}


module "secret" {
  source        = "../modules/secretsmanager_secret"
  name          = "test_secret_1"
  secret_string = random_password.master_password.result
  roles         = [aws_iam_role.test_role.arn, data.aws_caller_identity.current.arn]
}