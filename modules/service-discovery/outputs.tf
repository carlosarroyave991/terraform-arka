output "namespace_id" {
  description = "Service Discovery Namespace ID"
  value       = aws_service_discovery_private_dns_namespace.main.id
}

output "service_registry_arns" {
  description = "Service Registry ARNs"
  value       = { for k, v in aws_service_discovery_service.services : k => v.arn }
}

output "service_urls" {
  description = "Service URLs using DNS names"
  value = {
    for service_name, config in var.service_configs : service_name => "http://${service_name}.${var.environment}.local:${config.port}"
  }
}