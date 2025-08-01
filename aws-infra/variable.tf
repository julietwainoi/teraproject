variable "environment" {
  type        = string
  description = "The deployment environment (dev, staging, prod)."
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "app_name" {
  type        = string
  description = "The name of the application."
  default     = "node-express-app"
}

variable "eks_node_group_instance_type" {
  type        = string
  description = "The instance type for the EKS node group."
}

variable "eks_node_group_desired_capacity" {
  type        = number
  description = "The desired capacity for the EKS node group."
}