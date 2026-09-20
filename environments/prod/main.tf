module "vpc" {
  source = "../../modules/vpc"

  project_name = "urban-fantasy"
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = "urban-fantasy"
  vpc_id       = module.vpc.vpc_id
  admin_cidr   = var.admin_cidr
}

module "iam_roles" {
  source = "../../modules/iam-roles"

  project_name = "urban-fantasy"
}

module "ec2_ingress" {
  source = "../../modules/ec2-ingress"

  project_name          = "urban-fantasy"
  subnet_id             = module.vpc.public_subnet_ids[0]
  security_group_id     = module.security_groups.ingress_security_group_id
  instance_profile_name = module.iam_roles.ec2_instance_profile_name

  instance_type = "c7i-flex.large"
}

module "ec2_monitoring" {
  source = "../../modules/ec2-monitoring"

  project_name          = "urban-fantasy"
  subnet_id             = module.vpc.public_subnet_ids[1]
  security_group_id     = module.security_groups.monitoring_security_group_id
  instance_profile_name = module.iam_roles.ec2_instance_profile_name

  instance_type = "t3.small"
}

module "eks" {
  source = "../../modules/eks"

  project_name       = "urban-fantasy"
  subnet_ids         = module.vpc.public_subnet_ids
  cluster_role_arn   = module.iam_roles.eks_cluster_role_arn
  node_role_arn      = module.iam_roles.eks_node_role_arn
  kubernetes_version = "1.36"

  node_instance_type = "c7i-flex.large"

  depends_on = [module.iam_roles]
}