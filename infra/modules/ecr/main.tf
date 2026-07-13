resource "aws_ecr_repository" "app_repo" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  # This tells AWS: "Delete the repo even if it has images inside"
  force_delete = true
}

# Push a placeholder image immediately
resource "null_resource" "push_placeholder_image" {
    triggers = {
    repository_url = aws_ecr_repository.app_repo.repository_url
    }

  # Script runs on local machine during 'terraform apply'
  provisioner "local-exec" {
    # Uses && to chain commands together to avoid windows line ending problems
    command = "aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.app_repo.repository_url} && docker pull alpine:latest && docker tag alpine:latest ${aws_ecr_repository.app_repo.repository_url}:latest && docker push ${aws_ecr_repository.app_repo.repository_url}:latest"
  }

  # Ensure the repository exists before trying to push to it
  depends_on = [aws_ecr_repository.app_repo]
}