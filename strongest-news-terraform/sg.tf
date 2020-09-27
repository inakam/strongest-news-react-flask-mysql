resource "aws_security_group" "emtg-framework" {
  description = "AMP security group"

  name = "${var.name}-security-group"
  tags = {
    "Name" = "${var.name}"
  }
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "emtg-framework-to-out" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 0
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  protocol          = "-1"
  security_group_id = aws_security_group.emtg-framework.id
  self              = false
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "emtg-framework-from-internal" {
  cidr_blocks = [
    "10.0.0.0/16",
  ]
  from_port         = 0
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  protocol          = "-1"
  security_group_id = aws_security_group.emtg-framework.id
  self              = false
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "emtg-framework-from-lb-amp" {
  description              = "lb-amp security group"
  from_port                = 0
  ipv6_cidr_blocks         = []
  prefix_list_ids          = []
  protocol                 = "-1"
  security_group_id        = aws_security_group.emtg-framework.id
  source_security_group_id = aws_security_group.emtg-framework-lb.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group" "emtg-framework-lb" {
  description = "ELB AMP security group"
  name        = "${var.name}-lb"
  tags = {
    "Name" = "${var.name}-lb"
  }
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "lb-emtg-framework-from-http" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 80
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  protocol          = "tcp"
  security_group_id = aws_security_group.emtg-framework-lb.id
  self              = false
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "lb-emtg-framework-from-https" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 443
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  protocol          = "tcp"
  security_group_id = aws_security_group.emtg-framework-lb.id
  self              = false
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "lb-emtg-framework-to-out" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 0
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  protocol          = "-1"
  security_group_id = aws_security_group.emtg-framework-lb.id
  self              = false
  to_port           = 0
  type              = "egress"
}
