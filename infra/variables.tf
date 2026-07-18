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
  description = "Domain name for SSL"
  type        = string
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token for DNS validation"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The Zone ID from Cloudflare"
}