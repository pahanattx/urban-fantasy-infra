output "ingress_security_group_id" {
  value = aws_security_group.ingress.id
}

output "monitoring_security_group_id" {
  value = aws_security_group.monitoring.id
}