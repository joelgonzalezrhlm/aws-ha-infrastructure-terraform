variable "environment" {
  description = "Nombre del entorno (dev, prod, etc.)"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se crearán los Security Groups"
  type        = string
}

variable "common_tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
  default     = {}
}

variable "subnet_public_ids" {
  description = "IDs de las subredes publicas"
  type        = list(string)
}

variable "security_groups_ids" {
  description = "Lista de los IDs de los grupos de seguridad"
}

variable "target_group_port" {
  description = "Puerto de las instancias del ASG"
  type        = number
  default     = 80
}
