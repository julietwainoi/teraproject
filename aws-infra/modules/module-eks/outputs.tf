output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_certificate_authority" {
  description = "The base64 encoded certificate authority data."
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "kubeconfig" {
  description = "The configuration to connect to the cluster with kubectl."
  value = <<EOT
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks_cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks_cluster.certificate_authority[0].data}
  name: ${aws_eks_cluster.eks_cluster.name}
contexts:
- context:
    cluster: ${aws_eks_cluster.eks_cluster.name}
    user: ${aws_eks_cluster.eks_cluster.name}
  name: ${aws_eks_cluster.eks_cluster.name}
current-context: ${aws_eks_cluster.eks_cluster.name}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.eks_cluster.name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${aws_eks_cluster.eks_cluster.name}"
        - "--region"
        - "${data.aws_region.current.name}"
EOT
}