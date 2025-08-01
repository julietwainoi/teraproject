#--------------------------------------------------------------------------------
# EKS Cluster IAM Role
#--------------------------------------------------------------------------------
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.app_name}-${var.environment}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

#--------------------------------------------------------------------------------
# EKS Cluster
#--------------------------------------------------------------------------------
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.app_name}-${var.environment}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = "${var.app_name}-${var.environment}-cluster"
  }
}

#--------------------------------------------------------------------------------
# EKS Managed Node Group
#--------------------------------------------------------------------------------
resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.app_name}-${var.environment}-eks-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.app_name}-${var.environment}-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.eks_node_group_instance_type]

  scaling_config {
    desired_size = var.eks_node_group_desired_capacity
    max_size     = var.eks_node_group_max_capacity
    min_size     = var.eks_node_group_min_capacity
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-node-group"
    # Required for EKS cluster to discover and manage the nodes
    "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry_policy,
  ]
}