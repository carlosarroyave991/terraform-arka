resource "aws_lambda_function" "email_sender" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "${var.environment}-email-sender"
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 30

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SENDGRID_API_KEY = var.sendgrid_api_key
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  tags = {
    Name        = "${var.environment}-email-sender"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/email-sender.zip"
  source_dir  = "${path.module}/../lambda-code/email-sender"
}