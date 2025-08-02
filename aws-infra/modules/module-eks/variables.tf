variable "app_name" {
  type        = string
  description = "The name of the application, used for naming resources."
}

variable "environment" {
  type        = string
  description = "The deployment environment (dev, staging, prod)."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to deploy the EKS cluster into."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of private subnet IDs for the EKS workers."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "A list of public subnet IDs for the EKS control plane and load balancers."
}

variable "eks_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster."
  default     = "1.28"
}

variable "eks_node_group_instance_type" {
  type        = string
  description = "The instance type for the EKS node group."
}

variable "eks_node_group_desired_capacity" {
  type        = number
  description = "The desired capacity for the EKS node group."
  default     = 2
}

variable "eks_node_group_max_capacity" {
  type        = number
  description = "The maximum capacity for the EKS node group."
  default     = 3
}

variable "eks_node_group_min_capacity" {
  type        = number
  description = "The minimum capacity for the EKS node group."
  default     = 1
}