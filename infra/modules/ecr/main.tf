resource "aws_ecr_repository" "app_repo" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"
  
  # This tells AWS: "Delete the repo even if it has images inside"
  force_delete         = true
}

# Push a placeholder image immediately
resource "null_resource" "push_placeholder_image" {
  # Script runs on local machine during 'terraform apply'
  provisioner "local-exec" {
    command = <<EOT
      # Authenticate Docker with ECR registry
      aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.app_repo.repository_url}
      
      # Pull a tiny dummy image from Docker Hub
      docker pull alpine:latest
      
      # Tag it for your ECR and push it as 'latest'
      docker tag alpine:latest ${aws_ecr_repository.app_repo.repository_url}:latest
      docker push ${aws_ecr_repository.app_repo.repository_url}:latest
    EOT
  }

  # Ensure the repository exists before trying to push to it
  depends_on = [aws_ecr_repository.app_repo]
}