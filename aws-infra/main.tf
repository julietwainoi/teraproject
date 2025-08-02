provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket         = "jjuliet-terraform-state-bucket1234"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks" # optional but recommended
    encrypt        = true
  }
}

module "vpc" {
  source   = "./modules/module-vpc"
  name     = "vpc_network"
  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = {
    "us-east-1a" = "10.0.0.0/24"
    "us-east-1b" = "10.0.1.0/24"
  }

  private_subnet_cidrs = {
    "us-east-1a" = "10.0.2.0/24"
    "us-east-1b" = "10.0.3.0/24"
  }
}

# Call the ECR module
module "ecr" {
 source = "./modules/module-ecr"
  repository_name = var.app_name
}

# Call the EKS module
module "eks" {
 source = "./modules/module-eks"
 app_name = var.app_name
 environment                   = var.environment
 vpc_id                         = module.vpc.vpc_id
 public_subnet_ids             = module.vpc.public_subnets_ids
 private_subnet_ids            = module.vpc.private_subnets_ids
 eks_node_group_instance_type = var.eks_node_group_instance_type
 eks_node_group_desired_capacity = var.eks_node_group_desired_capacity
}