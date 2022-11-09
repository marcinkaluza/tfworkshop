module "s3_bucket"{
  source         = "./modules/s3_bucket"
  name_prefix = "kirils_bucket"
}