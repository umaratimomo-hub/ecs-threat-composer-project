output "alb_url" {
  description = "The public URL for the ThreatComposer application"
  value       = "http://${module.alb.alb_dns_name}"
}

output "ecr_repository_url" {
  description = "The URL for your ECR repository (use this for 'docker push')"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = module.ecs.service_name
}