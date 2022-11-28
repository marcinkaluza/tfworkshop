# Subnet group of subnets across which the rds cluster will deployed.
resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids
}

# Aurora RDS cluster
resource "aws_rds_cluster" "aurora" {
  #checkov:skip=CKV2_AWS_27: "Ensure Postgres RDS as aws_rds_cluster has Query Logging enabled"
  cluster_identifier                  = var.cluster_identifier
  engine                              = var.cluster_engine
  database_name                       = var.database_name
  master_username                     = var.master_username
  master_password                     = var.master_password
  db_subnet_group_name                = aws_db_subnet_group.subnet_group.name
  enable_http_endpoint                = var.enable_http_endpoint
  engine_mode                         = var.engine_mode
  vpc_security_group_ids              = var.security_group_ids
  port                                = var.port
  iam_database_authentication_enabled = true
  storage_encrypted                   = true
  deletion_protection                 = true
  skip_final_snapshot                 = true  # The cluster needs to be deleted and redeployed if this argument changes to false. The final_snpashot_identifier argument will also be required.
  apply_immediately                   = true 
}

# Creation of Aurora RDS instances in the cluster
resource "aws_rds_cluster_instance" "cluster_instances" {
  count                      = "${length(var.subnet_ids)}"    # Defines the number of instances that will be deployed in this cluster.
  identifier                 = "${aws_rds_cluster.aurora.cluster_identifier}-${count.index}"
  cluster_identifier         = aws_rds_cluster.aurora.id
  instance_class             = var.instance_class
  engine                     = aws_rds_cluster.aurora.engine
  engine_version             = aws_rds_cluster.aurora.engine_version
  monitoring_role_arn        = aws_iam_role.monitoring_role.arn
  monitoring_interval        = 5
  auto_minor_version_upgrade = true
}

resource "aws_iam_role" "monitoring_role" {
  name = "${aws_rds_cluster.aurora.cluster_identifier}-monitoring-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            Service = "monitoring.rds.amazonaws.com"
          }
          Effect = "Allow"
        }
      ]
  })
}

resource "aws_iam_role" "backup_role" {
  name = "${aws_rds_cluster.aurora.cluster_identifier}-backup-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            Service = "backup.amazonaws.com"
          }
          Effect = "Allow"
        }
      ]
  })
}

resource "aws_backup_vault" "backup_vault" {
# This is a false negative since the kms key arn is defined in the resources main.tf.
# checkov:skip=CKV_AWS_166: "Ensure Backup Vault is encrypted at rest using KMS CMK"
  name        = "${aws_rds_cluster.aurora.cluster_identifier}_backup_vault"
  kms_key_arn = var.backup_kms
}

resource "aws_backup_plan" "backup_plan" {
  name = "${aws_rds_cluster.aurora.cluster_identifier}_backup_plan"

  rule {
    rule_name         = "${aws_rds_cluster.aurora.cluster_identifier}_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 12 * * ? *)"
  }
}

resource "aws_backup_selection" "backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "${aws_rds_cluster.aurora.cluster_identifier}_backup_selection"
  plan_id      = aws_backup_plan.backup_plan.id

  resources = [
    aws_rds_cluster.aurora.arn
  ]
}