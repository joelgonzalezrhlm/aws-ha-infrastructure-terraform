variable "environment" {
  description = "Entorno de trabajo"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block para VPC"
  type        = string
}

variable "subnet_public_cidrs" {
  description = "Lista de CIDRs para las subredes públicas"
  type        = list(string)
}

variable "subnet_private_cidrs" {
  description = "Lista de CIDRs para las subredes privadas"
  type        = list(string)
}

variable "common_tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
  default     = {}
}