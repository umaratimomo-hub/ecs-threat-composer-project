variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "project_name" {
  description = "The name of the project to be used in tags"
  type        = string
}
# locals {
#   subnets = {
#     "public-a" = { cidr = "10.0.1.0/24", az = "eu-north-1a", public = true }
#     "public-b" = { cidr = "10.0.2.0/24", az = "eu-north-1b", public = true }
#     "private-a" = { cidr = "10.0.10.0/24", az = "eu-north-1a", public = false }
#     "private-b" = { cidr = "10.0.11.0/24", az = "eu-north-1b", public = false }
#   }
# }