variable "environment" {
  description = "Nombre del entorno (dev, prod, etc.)"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se crearan los Security Groups"
  type        = string
}

variable "common_tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
  default     = {}
}