resource "aws_launch_template" "web" {
  name_prefix   = "lt-web-${var.environment}"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_group_ids

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    env = var.environment
  }))

  iam_instance_profile {
    name = var.iam_profile_name
  }


  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.common_tags,
      { Name = "web-${var.environment}" }
    )
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "asg-web-${var.environment}"
  vpc_zone_identifier = var.subnet_public_ids

  target_group_arns = var.target_group_arns

  health_check_type         = "ELB"
  health_check_grace_period = 300

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Default"
  }

  tag {
    key                 = "Name"
    value               = "web-${var.environment}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 300
    }
  }
}

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "${var.asg_name}-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.web.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.target_cpu_utilization
  }
}
