variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "repo_names" {
  description = "Nombres de los repositorios ECR a crear"
  type        = list(string)
  default     = ["users", "products", "inventory", "orders"]
}

variable "aws_region" {
  description = "Región AWS donde se crearán los repos"
  type        = string
  default     = "us-east-1"
}

variable "app_ports" {
  description = "Puertos de la aplicación"
  default     = [8080, 8081, 8082, 8085]
}

variable "cpu" {
  description = "CPU de la tarea de ECS"
  default     = 256
}

variable "memory" {
  description = "Memoria de la tarea de ECS"
  default     = 512
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  sensitive   = true
}

variable "db_schema" {
  description = "Database schema"
  type        = string
  sensitive   = true
}

variable "sendgrid_api_key" {
  description = "SendGrid API Key para envío de emails"
  type        = string
  sensitive   = true
}

# JWT Configuration
variable "jwt_secret_key" {
  description = "JWT Secret Key"
  type        = string
  sensitive   = true
}

variable "jwt_expiration" {
  description = "JWT Expiration time in milliseconds"
  type        = string
  default     = "86400000"
}

variable "jwt_refresh_token" {
  description = "JWT Refresh token expiration in milliseconds"
  type        = string
  default     = "604800000"
}