terraform {

  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket       = "threat-composer-tf-state-umara-13245"
    region       = "eu-north-1"
    key          = "infra/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}