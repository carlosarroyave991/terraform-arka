variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "service_configs" {
  description = "Service configurations"
  type = map(object({
    port = number
    cpu  = number
    memory = number
  }))
}