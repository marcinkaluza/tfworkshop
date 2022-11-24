data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

#
# Encryption key
#

module "key" {
  source      = "../../kms"
  description = "KMS key for the API gateway logs"
  alias       = "cloudwatch/api/${var.api_id}/${var.stage_name}"
  services    = ["logs.${data.aws_region.current.name}.amazonaws.com"]
}
