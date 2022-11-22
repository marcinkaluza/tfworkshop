#
# Encryption key for the VPC flow logs
#
module "key" {
  source      = "../kms"
  alias       = "/vpc/logs"
  description = "KMS Key to encrypt VPC CloudWatch Log group"
  key_policy  = data.aws_iam_policy_document.vpc_log_group_kms_policy.json
}

#
# Key policy
#
data "aws_iam_policy_document" "vpc_log_group_kms_policy" {
  #checkov:skip=CKV_AWS_109: Policy gives permissions to KMS key only to CloudWatch Logs and only to the necessary Log Group
  #checkov:skip=CKV_AWS_111: Policy gives permissions to KMS key only to CloudWatch Logs and only to the necessary Log Group

  statement {
    sid    = "Allow S3 encryption"
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
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid    = "Allow admin access of key"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}


