terraform {
  required_version = "~> 1.0"

  backend "s3" {
    bucket         = ""
    dynamodb_table = ""
    key            = "terraform-state.tfstate"
    region         = "us-east-1"
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