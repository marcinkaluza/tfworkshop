data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

#
# Encryption key
#
resource "aws_kms_key" "key" {
  description             = var.description
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = var.key_policy != null ? var.key_policy : data.aws_iam_policy_document.default_policy[0].json
}

#
# Key alias
#
resource "aws_kms_alias" "alias" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.key.key_id
}

#
# Key access policy
#
# NOTE: 
# We have to ignore checkov warnings as we are using aws_iam_policy_document for a purpose it was not intended for.
# Key policies have to follow guidelines as per https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
# This means that the resource we use needs to be "*" and we also give unlimited permissions to account's root to allow 
# Administrators to manage the key.
#
data "aws_iam_policy_document" "default_policy" {
  count = length(var.roles) > 0 ? 1 : 0
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
  statement {
    sid       = "Admin Access"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.id}:root"]
    }
  }

  statement {
    sid    = "2"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = var.roles
    }
  }
}