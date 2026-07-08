variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "ecs-threat-composer-project" {
  description = "The name of the project, used to name the repository"
  type        = string
}

variable "image_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}