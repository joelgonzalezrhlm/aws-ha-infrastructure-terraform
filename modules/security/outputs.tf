output "alb_sg" {
  description = "ID del grupo de seguridad del ALB"
  value       = aws_security_group.alb_sg.id
}

output "web_sg" {
  description = "ID del grupo de seguridad del ASG"
  value       = aws_security_group.web_sg.id
}

output "bbdd_rds_sg" {
  description = "ID del grupo de seguridad del RDS"
  value       = aws_security_group.bbdd_rds_sg.id
}