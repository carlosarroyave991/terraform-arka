variable "environment" {
  description = "Environment name"
  type        = string
}

variable "service_names" {
  description = "List of service names for log groups"
  type        = set(string)
  default     = ["users", "products", "inventory", "orders"]
}

variable "log_retention_days" {
  description = "Log retention period in days"
  type        = number
  default     = 7  # 7 días para mantener costos bajos
}

variable "create_lambda_logs" {
  description = "Create log group for Lambda function"
  type        = bool
  default     = false
}