resource "aws_lb" "public" {
  name               = "alb-${var.environment}"
  load_balancer_type = "application"
  subnets            = var.subnet_public_ids
  security_groups    = var.security_groups_ids

  tags = merge(
    var.common_tags,
    { Name = "alb-${var.environment}" }
  )
}

resource "aws_lb_target_group" "tg_alb" {
  name        = "alb-target-group-${var.environment}"
  port        = var.target_group_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port" # Usa el puerto del target
    path                = "/"
    matcher             = "200-299" # Códigos OK (ajusta si tu app usa 200 solo)
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.common_tags,
    { Name = "alb-target-group-${var.environment}" }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb.arn
  }

  tags = merge(
    var.common_tags,
    { Name = "listener-http-${var.environment}" }
  )
}

