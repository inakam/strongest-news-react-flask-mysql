resource "aws_iam_instance_profile" "instance_role_ecs" {
  name = "instance_role_ecs"
  role = aws_iam_role.instance_role_ecs.name
}

resource "aws_iam_role" "instance_role_ecs" {
  name               = "instance_role_ecs_${var.name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "instance_role_policy_ecs" {
  name   = "instance_role_policy_ecs_${var.name}"
  role   = aws_iam_role.instance_role_ecs.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:UpdateContainerInstancesState",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_autoscaling_group" "ecs_autoscale" {
  availability_zones = [
    "ap-northeast-1a",
    "ap-northeast-1c",
  ]
  default_cooldown          = 300
  desired_capacity          = 2
  max_size                  = 2
  min_size                  = 2
  enabled_metrics           = []
  health_check_grace_period = 0
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.as_conf.name
  load_balancers            = []
  max_instance_lifetime     = 0
  metrics_granularity       = "1Minute"
  name                      = "amazon-ecs-${var.name}-asg"
  protect_from_scale_in     = false
  service_linked_role_arn   = aws_iam_service_linked_role.asg.arn
  suspended_processes       = []
  target_group_arns         = []
  termination_policies      = []
  vpc_zone_identifier = [
    var.public_subnet_1a,
    var.public_subnet_1c,
  ]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "ECS Instance - ${var.name}"
  }


  timeouts {}
}

resource "aws_launch_configuration" "as_conf" {
  associate_public_ip_address = true
  ebs_optimized               = false
  enable_monitoring           = true
  iam_instance_profile        = aws_iam_instance_profile.instance_role_ecs.name
  image_id                    = data.aws_ami.amazon_linux_ecs.id
  instance_type               = "t3.medium"
  key_name                    = "emtg-framework-2020"
  name                        = "amazon-ecs-${var.name}-cluster-lc"
  security_groups = [
    aws_security_group.emtg-framework.id
  ]
  user_data                        = templatefile("./templates/user_data.tpl", { cluster_name = aws_ecs_cluster.emtg-framework-cluster.name })
  vpc_classic_link_security_groups = []
}

resource "aws_iam_service_linked_role" "asg" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = var.name
  description      = "Default Service-Linked Role enables access to AWS Services and Resources used or managed by Auto Scaling"
}

