# Service Discovery Namespace
resource "aws_service_discovery_private_dns_namespace" "main" {
  name = "${var.environment}.local"
  vpc  = var.vpc_id

  tags = {
    Name        = "${var.environment}-service-discovery"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Service Discovery Services
resource "aws_service_discovery_service" "services" {
  for_each = var.service_configs

  name = each.key

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10      # Cache por 10 segundos
      type = "A"     # Registro tipo A (IP)
    }

    routing_policy = "MULTIVALUE"  # Balanceo si hay múltiples IPs
  }



  tags = {
    Name        = "${var.environment}-${each.key}-discovery"
    Environment = var.environment
    Service     = each.key
  }
}