resource "aws_security_group" "alb_sg" {
  description = "Permite todo el trafico exterior al puerto 80"
  name        = "alb-sg-${var.environment}"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "alb-sg-${var.environment}"
    }
  )
}

resource "aws_security_group" "web_sg" {
  description = "Permite trafico HTTP desde el ALB"
  name        = "web-sg-${var.environment}"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "web-sg-${var.environment}"
    }
  )
}

resource "aws_security_group" "bbdd_rds_sg" {
  description = "Permite el trafico a la base de datos desde las instancias web"
  name        = "bbdd-rds-sg-${var.environment}"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "bbdd-rds-sg-${var.environment}"
    }
  )
}