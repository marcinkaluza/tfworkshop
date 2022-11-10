provider "aws" {
  # Update desired region
  region = var.target_region
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}
