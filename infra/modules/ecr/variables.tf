variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}