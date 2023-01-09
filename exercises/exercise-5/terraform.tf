terraform {
  required_version = "~> 1.0"

  backend "s3" {
    bucket         = "tf-state-20230106094838506100000001"
    key            = "terraform-state.tfstate"
    dynamodb_table = "tf-locks"
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