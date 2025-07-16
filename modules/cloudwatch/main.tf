# CloudWatch Module - Log Groups para ECS

# Log Groups para cada servicio ECS
resource "aws_cloudwatch_log_group" "ecs_logs" {
  for_each = var.service_names

  name              = "${var.environment}-${each.value}-logs"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.environment}-${each.value}-logs"
    Environment = var.environment
    Service     = each.value
    ManagedBy   = "Terraform"
  }
}

# Log Group para Lambda (si necesitas)
resource "aws_cloudwatch_log_group" "lambda_logs" {
  count = var.create_lambda_logs ? 1 : 0
  
  name              = "/aws/lambda/${var.environment}-email-sender"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.environment}-lambda-logs"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}