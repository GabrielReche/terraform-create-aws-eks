# Adiciona o addon vpc-cni ao cluster EKS
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = module.eks.cluster_name  # Nome do cluster EKS
  addon_name                  = "vpc-cni"  # Nome do addon
  addon_version               = "v1.18.1-eksbuild.1"  # Versão do addon compatível com Kubernetes 1.29
  resolve_conflicts_on_create = "OVERWRITE"  # Resolve conflitos sobrescrevendo durante a criação
  resolve_conflicts_on_update = "OVERWRITE"  # Resolve conflitos sobrescrevendo durante a atualização
}

# Adiciona o addon kube-proxy ao cluster EKS
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.cluster_name  # Nome do cluster EKS
  addon_name   = "kube-proxy"  # Nome do addon
}

# Adiciona o addon coredns ao cluster EKS
resource "aws_eks_addon" "core_dns" {
  cluster_name = module.eks.cluster_name  # Nome do cluster EKS
  addon_name   = "coredns"  # Nome do addon
}

# Adiciona o addon aws-ebs-csi-driver ao cluster EKS
resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = module.eks.cluster_name  # Nome do cluster EKS
  addon_name               = "aws-ebs-csi-driver"  # Nome do addon
  service_account_role_arn = module.irsa_ebs_csi.iam_role_arn  # ARN da role de conta de serviço
  addon_version            = "v1.32.0-eksbuild.1"  # Versão do addon compatível com Kubernetes 1.29
}
