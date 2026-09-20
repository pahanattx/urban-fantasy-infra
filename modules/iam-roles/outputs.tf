output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_ssm.name
}

output "ec2_ssm_role_name" {
  value = aws_iam_role.ec2_ssm.name
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node.arn
}