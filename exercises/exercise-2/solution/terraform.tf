terraform {
  required_version = "~> 1.0"

  backend "s3" {
    bucket         = "tf-state-20221219133317074400000001"
    key            = "terraform-state.tfstate"
    dynamodb_table = "terraform-state-lock"
  }


  required_providers {
    aws = {
      version = "4.45"
    }
  }
}