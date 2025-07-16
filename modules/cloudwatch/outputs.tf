output "log_group_names" {
  description = "Names of created log groups"
  value       = { for k, v in aws_cloudwatch_log_group.ecs_logs : k => v.name }
}

output "log_group_arns" {
  description = "ARNs of created log groups"
  value       = { for k, v in aws_cloudwatch_log_group.ecs_logs : k => v.arn }
}