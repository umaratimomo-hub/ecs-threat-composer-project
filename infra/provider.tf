provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "Dev"
      Project     = "ThreatComposer"
      Repository  = "ecs-threat-composer-project"
      ManagedBy   = "Terraform"
    }
  }
}