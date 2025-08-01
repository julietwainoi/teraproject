output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "kubeconfig" {
  value = module.eks.kubeconfig
  sensitive = true
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}