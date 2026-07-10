variable "project_name" {
  description = "The exact name of the ECR repository"
  type        = string
}

# variable "repository_name" {
#   description = "The exact name of the ECR repository"
#   type        = string
# }

variable "image_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}