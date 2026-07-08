output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs for the Load Balancer"
  value = [
    aws_subnet.network["public-a"].id,
    aws_subnet.network["public-b"].id
  ]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs for ECS and VPC Endpoints"
  value = [
    aws_subnet.network["private-a"].id,
    aws_subnet.network["private-b"].id
  ]
}