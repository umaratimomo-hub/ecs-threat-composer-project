variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the endpoints and security groups"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ECS tasks and endpoints"
  type        = list(string)
}

variable "private_route_table_id" {
  description = "The route table ID for the S3 Gateway Endpoint"
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the ALB security group to allow ingress traffic"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN for the ECS service to register with"
  type        = string
}

variable "app_port" {
  type        = number
  description = "The port the container listens on (e.g., 8080 or 80)"
  default     = 8080
}

variable "container_cpu" {
  type        = string
  description = "Fargate vCPU units (256, 512, 1024, etc.)"
  default     = "256"
}

variable "container_memory" {
  type        = string
  description = "Fargate memory limits (512, 1024, 2048, etc.)"
  default     = "512"
}

variable "repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}

