module "s3_bucket" "my_bucket" {
  source         = "./modules/s3_bucket"
  buckety_prefis = "kirils_bucket"
}