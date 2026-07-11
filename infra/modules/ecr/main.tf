resource "aws_ecr_repository" "app" {
  name                 = var.project_name
  image_tag_mutability = var.image_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = {
    Name = var.project_name
  }
}

# ------------------------------------------------------------------------------
# ECR LIFECYCLE POLICY
# ------------------------------------------------------------------------------

resource "aws_ecr_lifecycle_policy" "cleanup" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Purge untagged (dangling) images quickly to save storage costs"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = var.untagged_image_retention
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep the last ${var.tagged_image_retention} formally tagged images"
        selection = {
          tagStatus   = "tagged"
          # ECR requires a prefix list when using 'tagged', a wildcard keeps them all in scope
          tagPrefixList = ["v", "latest", "prod", "dev", "threat-composer"] 
          countType     = "imageCountMoreThan"
          countNumber   = var.tagged_image_retention
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}