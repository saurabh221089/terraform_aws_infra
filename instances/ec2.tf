provider "aws" {
  #access_key = "ACCESS_KEY_HERE"
  #secret_key = "SECRET_KEY_HERE"
  region = var.region
}

terraform {
  backend "s3" {
  }
}

data "template_file" "myuserdata" {
  template = file("userdata.tpl")
}

/* data "aws_ami" "launch_config_ami" {
  most_recent = true
  owners      = "amazon"

  filter {
    name      = "owner-alias"
    values    = ["amazon"]
  }
} */

data "terraform_remote_state" "net_config" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
    region = var.region
  }
}

resource "aws_security_group" "tf_public_sec_grp" {
  vpc_id      = "${data.terraform_remote_state.net_config.outputs.vpc_id}"
  description = "tf_public_sec_grp"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow incoming traffic on Port 80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow incoming SSH traffic"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb_security_group" {
  description = "ELB Security Group"
  vpc_id      = "${data.terraform_remote_state.net_config.outputs.vpc_id}"

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow web traffic to load balancer"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "ec2_public_launch_configuration" {
  image_id                    = "ami-040c7ad0a93be494e"
  instance_type               = var.instance_type
  key_name                    = var.keypair
  associate_public_ip_address = true
  security_groups             = [aws_security_group.tf_public_sec_grp.id]
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  user_data                   = data.template_file.myuserdata.template
}

resource "aws_elb" "webapp_load_balancer" {
  name            = "WebApp-LoadBalancer"
  internal        = false
  security_groups = [aws_security_group.elb_security_group.id]
  subnets = [
    data.terraform_remote_state.net_config.outputs.public_subnet_1_id,
    data.terraform_remote_state.net_config.outputs.public_subnet_2_id
  ]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    healthy_threshold   = 5
    interval            = 30
    target              = "HTTP:80/index.html"
    timeout             = 10
    unhealthy_threshold = 5
  }
}

resource "aws_autoscaling_group" "ec2_public_autoscaling_group" {
  name = "WebApp-AutoScalingGroup"
  vpc_zone_identifier = [
    data.terraform_remote_state.net_config.outputs.public_subnet_1_id,
    data.terraform_remote_state.net_config.outputs.public_subnet_2_id
  ]

  max_size             = var.max_instance_size
  min_size             = var.min_instance_size
  launch_configuration = aws_launch_configuration.ec2_public_launch_configuration.name
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.webapp_load_balancer.name]

  tag {
    key                 = "Name"
    propagate_at_launch = false
    value               = "WebApp-EC2-Instance"
  }

  tag {
    key                 = "Type"
    propagate_at_launch = false
    value               = "WebApp"
  }
}

resource "aws_autoscaling_policy" "webapp_scaling_policy" {
  autoscaling_group_name   = aws_autoscaling_group.ec2_public_autoscaling_group.name
  name                     = "WebApp-AutoScaling-Policy"
  policy_type              = "TargetTrackingScaling"
  min_adjustment_magnitude = 1

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60
  }
}

resource "aws_sns_topic" "webapp_autoscaling_alert_topic" {
  display_name = "WebApp-AutoScaling-Topic"
  name         = "WebApp-AutoScaling-Topic"
}

resource "aws_sns_topic_subscription" "webapp_autoscaling_sms_subscription" {
  endpoint  = var.PHONE_NUMBER
  protocol  = "sms"
  topic_arn = aws_sns_topic.webapp_autoscaling_alert_topic.arn
}

resource "aws_autoscaling_notification" "webapp_autoscaling_notification" {
  group_names = [aws_autoscaling_group.ec2_public_autoscaling_group.name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]
  topic_arn = aws_sns_topic.webapp_autoscaling_alert_topic.arn
}

/* resource "aws_instance" "tf-ec2" {
  ami                         = "${data.aws_ami.launch_config_ami.id}"
  instance_type               = "${var.instance_type}"
  key_name		                = "${var.keypair}"
  vpc_security_group_ids      = ["${aws_security_group.tf_sec_grp.id}"]
  subnet_id		                = "${aws_subnet.tf_public_subnet1.id}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.myuserdata.template}"
  depends_on                  = ["aws_security_group.tf_public_sec_grp"]

  tags = {
    Name                      = "TF-EC2"
  }
} */
