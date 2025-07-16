output "repository_urls" {
  description = "URLs de los repositorios ECR creados"
  value       = { for repo in aws_ecr_repository.repos : repo.name => repo.repository_url }
}

output "repository_arns" {
  description = "ARNs de los repositorios ECR"
  value       = { for repo in aws_ecr_repository.repos : repo.name => repo.arn }
}

output "registry_id" {
  description = "ID del registro ECR (mismo para todos los repositorios)"
  value       = values(aws_ecr_repository.repos)[0].registry_id
}

output "registry_url" {
  description = "URL base del registro ECR"
  value       = "${values(aws_ecr_repository.repos)[0].registry_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}