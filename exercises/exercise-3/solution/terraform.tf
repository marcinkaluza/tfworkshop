terraform {
  required_version = "~> 1.0"

  backend "s3" {
    bucket         = ""
    key            = "terraform-state.tfstate"
    dynamodb_table = ""
  }


  required_providers {
    aws = {
      version = "4.45"
    }
  }
}

provider "aws" {
  region = var.target_region
}