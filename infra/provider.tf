provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      Environment = "Dev"
      Project     = "ThreatComposer"
      ManagedBy   = "Terraform"
    }
  }
}