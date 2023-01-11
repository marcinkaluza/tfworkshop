terraform {
  required_version = "~> 1.3.6"

  required_providers {
    # AWS Provider configuration 
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    # TODO: Add AWS Provider
  }
}

provider aws {
  #TODO: Specify region for the deployment using target_region variable
}

