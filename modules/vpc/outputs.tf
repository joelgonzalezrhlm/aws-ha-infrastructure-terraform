output "subnet_public_id" {
  description = "IDs de las subredes públicas"
  value       = aws_subnet.public[*].id
}

output "subnet_private_id" {
  description = "IDs de las subredes privadas"
  value       = aws_subnet.private[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "account_id" {
  description = "ID del usuario usado"
  value       = data.aws_caller_identity.current.id
}