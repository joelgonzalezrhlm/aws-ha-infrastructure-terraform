locals {
  db_password_version = 1
}

ephemeral "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "arn:aws:secretsmanager:eu-south-2:435717710769:secret:rdspassword-9hr1no"
}

resource "aws_db_subnet_group" "main" {
  name       = "rds-${var.environment}"
  subnet_ids = var.subnet_private_ids

  tags = merge(
    var.common_tags,
    {
      Name = "rds-${var.environment}"
    }
  )
}

resource "aws_db_instance" "rds" {
  identifier = "rds-${var.environment}"

  engine         = "mysql"
  engine_version = "8.4.7"
  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp2"

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 0
  backup_window           = "03:00-04:00"
  maintenance_window      = "Sun:00:00-Sun:03:00"

  db_name  = "miapp"
  password_wo         = jsondecode(ephemeral.aws_secretsmanager_secret_version.db_password.secret_string).password
  password_wo_version = local.db_password_version

  skip_final_snapshot = true
  #deletion_protection = true

  tags = merge(
    var.common_tags,
    {
      Name = "rds-${var.environment}"
    }
  )
}
