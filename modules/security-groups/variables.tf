variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups are created"
  type        = string
}

variable "admin_cidr" {
  description = "Trusted public IP allowed to access admin interfaces"
  type        = string
}