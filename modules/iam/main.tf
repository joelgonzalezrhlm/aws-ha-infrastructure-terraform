resource "aws_iam_role" "ec2_ssm" {
  name = "ec2-ssm-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm_agent" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # SSM + logs
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "ec2-ssm-${var.environment}"
  role = aws_iam_role.ec2_ssm.name
}

