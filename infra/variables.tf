variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "threat-composer"
}

variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "eu-north-1"
}

variable "domain_name" {
  description = "Optional: Domain name for SSL"
  type        = string
  default     = ""
}