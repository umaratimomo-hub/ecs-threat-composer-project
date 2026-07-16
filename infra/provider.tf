provider "aws" {
  # Region inheritterd from github

  default_tags {
    tags = {
      Environment = "Production"
      Project     = var.project_name
      Repository  = "ecs-threat-composer-project"
      ManagedBy   = "Terraform"
    }
  }
}