variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB security group will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "The list of public subnet IDs to host the ALB"
  type        = list(string)
}

variable "domain_name" {
  description = "The primary domain name for the ACM SSL certificate"
  type        = string
  default     = ""
}

variable "route53_zone_id" {
  description = "The Route 53 Hosted Zone ID for domain validation"
  type        = string
  default     = ""
}