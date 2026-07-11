terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# migrate local state to the S3 bucket after apply.
  #
  # backend "s3" {
  #   bucket         = "threat-composer-tf-state-umara-13245"
  #   key            = "bootstrap/terraform.tfstate"
  #   region         = "eu-north-1"
  #   encrypt        = true
  # }