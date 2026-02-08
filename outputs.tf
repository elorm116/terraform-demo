output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "node_group_role_arn" {
  description = "Node group IAM role ARN"
  value       = module.eks.eks_managed_node_groups["worker_group_1"].iam_role_arn
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN (for IRSA)"
  value       = module.eks.oidc_provider_arn
}

output "configure_kubeconfig" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region} --kubeconfig ~/.kube/config-eks-myapp"
}