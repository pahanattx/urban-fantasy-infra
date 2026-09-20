output "instance_id" {
  value = aws_instance.ingress.id
}

output "public_ip" {
  value = aws_instance.ingress.public_ip
}

output "private_ip" {
  value = aws_instance.ingress.private_ip
}