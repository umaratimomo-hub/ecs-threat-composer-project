output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}