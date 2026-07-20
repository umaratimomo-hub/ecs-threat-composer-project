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

variable "app_port" {
  type        = number
  description = "The port the application backend listens on"
  default     = 80
}

variable "http_port" {
  type        = number
  description = "The standard HTTP listener port"
  default     = 80
}

variable "https_port" {
  type        = number
  description = "The standard HTTPS listener port"
  default     = 443
}

variable "health_check_path" {
  type        = string
  description = "The endpoint the ALB pings to check container health"
  default     = "/"
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "certificate_arn" {
  description = "The ARN of the validated ACM certificate"
  type        = string
  default     = ""
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare Zone ID for creating the subdomain CNAME record"
  type        = string
}