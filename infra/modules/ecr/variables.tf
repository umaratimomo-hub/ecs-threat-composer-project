variable "project_name" {
  description = "The exact name of the ECR repository"
  type        = string
}

variable "image_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  type        = bool
  description = "Enable vulnerability scanning on image push"
  default     = true
}

variable "tagged_image_retention" {
  type        = number
  description = "Number of tagged images to keep"
  default     = 5
}

variable "untagged_image_retention" {
  type        = number
  description = "Number of untagged images to keep before deletion"
  default     = 1
}