module "bootstrap" {
  source = "trussworks/bootstrap/aws"
  region               = var.target_region
  account_alias        = var.account_alias
  manage_account_alias = false
}


