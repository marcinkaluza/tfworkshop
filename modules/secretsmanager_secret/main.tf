#
# Encryption key
#
module "key" {
  source      = "../kms"
  description = "KMS key for the ${var.name} SecretManager secret"
  alias       = "secretmanager/${var.name}"
  roles       = var.roles
}

#
# Secret
#
resource "aws_secretsmanager_secret" "secret" {
  name       = var.name
  kms_key_id = module.key.arn
}

#
# Secret version
#
resource "aws_secretsmanager_secret_version" "version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.secret_string
}

#
# Secret rotation
#
resource "aws_secretsmanager_secret_rotation" "rotation" {
  count = var.rotation_lambda_arn != null ? 1 : 0

  secret_id           = aws_secretsmanager_secret.secret.id
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.rotation_interval
  }
}