output "alb_url" {
  description = "The public URL for the ThreatComposer application"
  value       = "http://${module.alb.alb_dns_name}"
}

output "ecr_url" {
  value = module.ecr.repository_url
  description = "The URL of the ECR repository"
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = module.ecs.service_name
}