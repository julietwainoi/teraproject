variable "name" {
  type        = string
  description = "Prefix name for resources"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type = map(string)
  description = "Map of AZ => CIDR for public subnets"
}

variable "private_subnet_cidrs" {
  type = map(string)
  description = "Map of AZ => CIDR for private subnets"
}
