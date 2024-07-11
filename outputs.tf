# Arquivo de saídas do Terraform

# Saída que fornece o endpoint do plano de controle do EKS
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"  # Descrição da saída
  value       = module.eks.cluster_endpoint  # Valor da saída, obtido do módulo EKS
}

# Saída que fornece os IDs dos grupos de segurança anexados ao plano de controle do cluster
output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"  # Descrição da saída
  value       = module.eks.cluster_security_group_id  # Valor da saída, obtido do módulo EKS
}

# Saída que fornece a região AWS utilizada
output "region" {
  description = "AWS region"  # Descrição da saída
  value       = var.region  # Valor da saída, obtido da variável de região
}

# Saída que fornece o nome do cluster Kubernetes
output "cluster_name" {
  description = "Kubernetes Cluster Name"  # Descrição da saída
  value       = module.eks.cluster_name  # Valor da saída, obtido do módulo EKS
}
