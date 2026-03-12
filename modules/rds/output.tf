output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "rds_secret_arn" {
  description = "ARN del secreto de credenciales RDS"
  value       = try(aws_db_instance.rds.master_user_secret[0].secret_arn, null)
}
