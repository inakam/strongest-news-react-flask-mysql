resource "aws_ecs_cluster" "emtg-framework-cluster" {
  capacity_providers = []

  name = "${var.name}-cluster"
  tags = {}

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "emtg-framework-service" {
  cluster                            = aws_ecs_cluster.emtg-framework-cluster.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  enable_ecs_managed_tags            = false
  health_check_grace_period_seconds  = 0
  launch_type                        = "EC2"
  name                               = "${var.name}-service"
  scheduling_strategy                = "REPLICA"
  tags                               = {}
  task_definition                    = aws_ecs_task_definition.emtg-framework.arn
  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    container_name   = "react-client"
    container_port   = 3000
    target_group_arn = aws_alb_target_group.alb-1.arn
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }
  ordered_placement_strategy {
    field = "instanceId"
    type  = "spread"
  }

  service_registries {
    container_name = "react-client"
    container_port = 3000
    port           = 0
    registry_arn   = aws_service_discovery_service.emtg-framework.arn
  }

  depends_on = [
    aws_alb.alb
  ]
}

resource "aws_service_discovery_private_dns_namespace" "emtg-framework" {
  name        = "${var.name}.local"
  description = var.name
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "emtg-framework" {
  name         = "${var.name}-pipeline-service"
  namespace_id = aws_service_discovery_private_dns_namespace.emtg-framework.id

  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.emtg-framework.id
    routing_policy = "MULTIVALUE"

    dns_records {
      ttl  = 60
      type = "SRV"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_task_definition" "emtg-framework" {
  family = var.name
  container_definitions = templatefile("./task-definitions/init_taskdef.json", {
    ecr_name_flask = aws_ecr_repository.emtg-framework-flask.name,
    ecr_name_react = aws_ecr_repository.emtg-framework-react.name,
    ecr_name_nginx = aws_ecr_repository.emtg-framework-nginx.name,
    ecr_name_mysql = aws_ecr_repository.emtg-framework-mysql.name,
    name = var.name
  })
}

resource "aws_cloudwatch_log_group" "ecs-flask" {
  name = "ecs-flask-${var.name}"

  tags = {
    Environment = "development"
    Application = "flask"
  }
}

resource "aws_cloudwatch_log_group" "ecs-react" {
  name = "ecs-react-${var.name}"

  tags = {
    Environment = "development"
    Application = "react"
  }
}

resource "aws_cloudwatch_log_group" "ecs-mysql" {
  name = "ecs-mysql-${var.name}"

  tags = {
    Environment = "development"
    Application = "mysql"
  }
}

resource "aws_cloudwatch_log_group" "ecs-nginx" {
  name = "ecs-nginx-${var.name}"

  tags = {
    Environment = "development"
    Application = "nginx"
  }
}
