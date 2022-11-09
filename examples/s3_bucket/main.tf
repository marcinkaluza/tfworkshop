#
# Simplest of buckets
#
module "simple_bucket" {
  source      = "../../modules/s3_bucket"
  name_prefix = "simple-bucket"
}