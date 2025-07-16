output "lambda_function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.email_sender.arn
}

output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.email_sender.function_name
}

output "lambda_invoke_arn" {
  description = "ARN de invocación de la función Lambda"
  value       = aws_lambda_function.email_sender.invoke_arn
}