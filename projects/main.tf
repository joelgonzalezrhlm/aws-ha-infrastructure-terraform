locals {
  env = "production"

  common_tags = {
    Environment = local.env
    Managed_By  = "Terraform"
    Project     = "aws-ha-infrastructure-terraform"
  }
}

module "vpc" {
  source = "../modules/vpc"

  environment          = local.env
  vpc_cidr             = "10.0.0.0/16"
  subnet_public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_private_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  common_tags          = local.common_tags
}

module "security" {
  source = "../modules/security"

  environment = local.env
  vpc_id      = module.vpc.vpc_id
  common_tags = local.common_tags
}

module "alb" {
  source = "../modules/alb"

  environment         = local.env
  vpc_id              = module.vpc.vpc_id
  subnet_public_ids   = module.vpc.subnet_public_id
  security_groups_ids = [module.security.alb_sg]
  common_tags         = local.common_tags
}

module "rds" {
  source = "../modules/rds"

  environment        = local.env
  vpc_id             = module.vpc.vpc_id
  common_tags        = local.common_tags
  security_group_id  = module.security.bbdd_rds_sg
  subnet_private_ids = module.vpc.subnet_private_id
}

module "iam" {
  source         = "../modules/iam"
  environment    = local.env
  common_tags    = local.common_tags
}

module "asg" {
  source = "../modules/asg"

  environment         = local.env
  asg_name            = "asg-web-${local.env}"
  vpc_id              = module.vpc.vpc_id
  subnet_public_ids   = module.vpc.subnet_public_id
  security_group_ids  = [module.security.web_sg]
  common_tags         = local.common_tags
  target_group_arns   = [module.alb.target_group_arn]
  ami_id              = "ami-0ea1dc7d933cc2e03"
  iam_profile_name    = module.iam.instance_profile_name
}

output "alb_dns_name" {
  description = "DNS del ALB (ábrelo en navegador)"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "Endpoint de la base de datos"
  value       = module.rds.rds_endpoint
}
