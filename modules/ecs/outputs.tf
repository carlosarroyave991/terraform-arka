output "cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.main.name
}

output "service_arns" {
  description = "ECS Service ARNs"
  value       = { for k, v in aws_ecs_service.services : k => v.id }
}

output "task_definition_arns" {
  description = "Task Definition ARNs"
  value       = { for k, v in aws_ecs_task_definition.services : k => v.arn }
}

output "service_info" {
  description = "Información para acceder a los servicios"
  value = {
    cluster_name = aws_ecs_cluster.main.name
    services = {
      for k, v in var.service_configs : k => {
        service_name = "${var.environment}-${k}-service"
        port = v.port
        note = "Usar AWS CLI para obtener IP pública"
      }
    }
  }
}

output "service_urls" {
  description = "URLs base de los servicios (requiere IPs públicas)"
  value = {
    for service_name, config in var.service_configs : service_name => {
      port = config.port
      url_template = "http://[IP_PUBLICA]:${config.port}"
    }
  }
}