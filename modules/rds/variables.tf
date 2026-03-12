variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_private_ids" {
  type = list(string)
}

variable "security_group_id" {
  description = "SG de la RDS"
  type        = string
}
