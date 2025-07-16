variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "repository_urls" {
  description = "ECR repository URLs"
  type        = map(string)
}

variable "ecs_execution_role_arn" {
  description = "ARN del rol de ejecución de ECS"
  type        = string
}

variable "service_configs" {
  description = "Service configurations"
  type = map(object({
    port = number
    cpu  = number
    memory = number
  }))
  default = {
    users     = { port = 8080, cpu = 256, memory = 512 }
    products  = { port = 8081, cpu = 256, memory = 512 }
    inventory = { port = 8082, cpu = 256, memory = 512 }
    orders    = { port = 8085, cpu = 256, memory = 512 }
  }
}

variable "container_environment" {
  description = "Container environment variables"
  type = map(list(object({name = string, value = string})))
  default = {}
}

variable "aws_region" {
  description = "Región AWS donde se crearán los repos"
  type        = string
}

variable "service_registry_arns" {
  description = "Service Registry ARNs for service discovery"
  type        = map(string)
  default     = {}
}