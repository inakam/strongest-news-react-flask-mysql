resource "aws_alb" "alb" {
  name                       = var.name
  security_groups            = [aws_security_group.emtg-framework-lb.id]
  subnets                    = [var.public_subnet_1a, var.public_subnet_1c]
  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.alb_log.bucket
    enabled = true
  }
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb-1.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "alb-1" {
  name     = "${var.name}-tg-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_target_group" "alb-2" {
  name     = "${var.name}-tg-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}
