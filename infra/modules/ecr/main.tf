resource "aws_ecr_repository" "app" {
  name                 = var.repository_name
  image_tag_mutability = var.image_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = var.repository_name
  }
}

# Add a lifecycle policy so untagged images don't accumulate costs
resource "aws_ecr_lifecycle_policy" "cleanup" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 tagged images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}