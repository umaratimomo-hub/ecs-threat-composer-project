output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name 
}

output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.app.name
} 

output "task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}