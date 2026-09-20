resource "aws_security_group" "ingress" {
  name        = "${var.project_name}-ingress-sg"
  description = "Security group for Jenkins and NGINX ingress server"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-ingress-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.ingress.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  description = "Public HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.ingress.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  description = "Public HTTPS"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins" {
  security_group_id = aws_security_group.ingress.id
  cidr_ipv4         = var.admin_cidr
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"

  description = "Jenkins access from admin IP"
}

resource "aws_security_group" "monitoring" {
  name        = "${var.project_name}-monitoring-sg"
  description = "Security group for Prometheus and Grafana"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-monitoring-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "grafana" {
  security_group_id = aws_security_group.monitoring.id
  cidr_ipv4         = var.admin_cidr
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"

  description = "Grafana access from admin IP"
}

resource "aws_vpc_security_group_ingress_rule" "prometheus" {
  security_group_id = aws_security_group.monitoring.id
  cidr_ipv4         = var.admin_cidr
  from_port         = 9090
  to_port           = 9090
  ip_protocol       = "tcp"

  description = "Prometheus access from admin IP"
}

resource "aws_vpc_security_group_ingress_rule" "node_exporter" {
  security_group_id            = aws_security_group.ingress.id
  referenced_security_group_id = aws_security_group.monitoring.id
  from_port                    = 9100
  to_port                      = 9100
  ip_protocol                  = "tcp"

  description = "Node Exporter access from monitoring server"
}

resource "aws_vpc_security_group_egress_rule" "ingress_outbound" {
  security_group_id = aws_security_group.ingress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "monitoring_outbound" {
  security_group_id = aws_security_group.monitoring.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}