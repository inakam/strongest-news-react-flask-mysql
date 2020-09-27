resource "aws_ecr_repository" "emtg-framework-flask" {
  image_tag_mutability = "MUTABLE"
  name                 = "ecr-${var.name}-flask"
  tags                 = {}

  image_scanning_configuration {
    scan_on_push = true
  }

  timeouts {}
}

resource "aws_ecr_repository" "emtg-framework-react" {
  image_tag_mutability = "MUTABLE"
  name                 = "ecr-${var.name}-react"
  tags                 = {}

  image_scanning_configuration {
    scan_on_push = true
  }

  timeouts {}
}

resource "aws_ecr_repository" "emtg-framework-nginx" {
  image_tag_mutability = "MUTABLE"
  name                 = "ecr-${var.name}-nginx"
  tags                 = {}

  image_scanning_configuration {
    scan_on_push = true
  }

  timeouts {}
}

resource "aws_ecr_repository" "emtg-framework-mysql" {
  image_tag_mutability = "MUTABLE"
  name                 = "ecr-${var.name}-mysql"
  tags                 = {}

  image_scanning_configuration {
    scan_on_push = true
  }

  timeouts {}
}