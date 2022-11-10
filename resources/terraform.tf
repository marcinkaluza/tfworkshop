terraform {
  required_version = "~> 1.0"
  backend "s3" {
  }

  required_providers {
    aws = {
      version               = "4.11"
      configuration_aliases = [aws, aws.us_east]
    }
  }
}
