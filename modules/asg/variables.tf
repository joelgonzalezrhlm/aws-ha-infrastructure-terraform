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

variable "subnet_public_ids" {
  description = "Subredes públicas para el ASG"
  type        = list(string)
}

variable "security_group_ids" {
  description = "SGs para las instancias"
  type        = list(string)
}

variable "target_group_arns" {
  description = "ARN del target group del ALB"
  type        = list(string)
}

variable "instance_type" {
  description = "Tipo de instancia Free Tier"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI de Amazon Linux 2023 (Free Tier)"
  type        = string
}

variable "asg_name" {
  type = string
}

variable "target_cpu_utilization" {
  description = "CPU objetivo para target tracking"
  type        = number
  default     = 60
}

variable "iam_profile_name" {
  description = "Nombre del IAM Instance Profile para las instancias del ASG"
  type        = string
}