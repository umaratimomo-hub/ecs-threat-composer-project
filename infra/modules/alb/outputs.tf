output "alb_security_group_id" {
  description = "The ID of the ALB Security Group (needed by the ECS Task Security Group)"
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "The Target Group ARN (needed by the ECS Service)"
  value       = aws_lb_target_group.app.arn
}

output "alb_dns_name" {
  description = "The public DNS name of the Load Balancer"
  value       = aws_lb.main.dns_name
}