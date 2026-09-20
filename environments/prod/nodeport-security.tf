resource "aws_vpc_security_group_ingress_rule" "eks_nodeport_http_from_gateway" {
  security_group_id            = module.eks.cluster_security_group_id
  referenced_security_group_id = module.security_groups.ingress_security_group_id

  ip_protocol = "tcp"
  from_port   = 30080
  to_port     = 30080
}