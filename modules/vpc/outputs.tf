output "vpc_id" {
  description = "ID de la VPC"
  value       = data.aws_vpc.default.id
}

output "subnet_ids" {
  description = "IDs de las subnets disponibles"
  value       = data.aws_subnets.default.ids
}

output "app_security_group_id" {
  description = "ID del security group para aplicaciones"
  value       = aws_security_group.app.id
}

output "database_security_group_id" {
  description = "ID del security group para base de datos"
  value       = aws_security_group.database.id
}