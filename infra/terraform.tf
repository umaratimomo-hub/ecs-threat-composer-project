terraform {

  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    # Bucket and region inheritted from github
    key          = "infra/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
