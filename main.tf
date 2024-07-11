# Define o provedor AWS e a região a ser utilizada
provider "aws" {
  region = var.region  # Região AWS a ser utilizada, fornecida por uma variável
}

# Obtém as zonas de disponibilidade disponíveis na região especificada
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"  # Filtra as zonas de disponibilidade que não exigem opt-in
    values = ["opt-in-not-required"]
  }
}

# Define um local para o nome do cluster
locals {
  cluster_name = var.cluster_name  # Nome do cluster, fornecido por uma variável
}

# Cria uma string aleatória de 8 caracteres para ser usada como sufixo
resource "random_string" "suffix" {
  length  = 8  # Comprimento da string
  special = false  # Sem caracteres especiais
}

# Módulo IRSA para EBS CSI
module "irsa_ebs_csi" {
  source = "./modules/irsa_ebs_csi"  # Caminho do módulo IRSA EBS CSI
  # Defina as variáveis conforme necessário
}

# Módulo VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"  # Fonte do módulo VPC
  version = "5.0.0"  # Versão do módulo

  name = "cluster-vpc"  # Nome da VPC

  cidr = var.cidr  # CIDR da VPC, fornecido por uma variável
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)  # Seleciona as 3 primeiras zonas de disponibilidade

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  # Sub-redes privadas
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]  # Sub-redes públicas

  enable_nat_gateway   = var.enable_nat_gateway  # Habilita o NAT Gateway, se necessário
  single_nat_gateway   = var.single_nat_gateway  # Habilita o uso de um único NAT Gateway
  enable_dns_hostnames = var.enable_dns_hostnames  # Habilita nomes DNS para instâncias na VPC

  public_subnet_tags = {  # Tags para sub-redes públicas
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {  # Tags para sub-redes privadas
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

# Módulo EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"  # Fonte do módulo EKS
  version = "19.15.3"  # Versão do módulo

  cluster_name                         = local.cluster_name  # Nome do cluster
  cluster_version                      = var.eks_version  # Versão do EKS, fornecida por uma variável
  vpc_id                               = module.vpc.vpc_id  # ID da VPC
  subnet_ids                           = module.vpc.private_subnets  # IDs das sub-redes privadas
  cluster_endpoint_public_access       = true  # Habilita acesso público ao endpoint do cluster
  cluster_endpoint_private_access      = true  # Habilita acesso privado ao endpoint do cluster
  cluster_enabled_log_types            = var.cluster_enabled_log_types  # Tipos de logs habilitados para o cluster
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs  # CIDRs permitidos para acesso público ao endpoint do cluster

  # Configurações padrão para grupos de nós gerenciados pelo EKS
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"  # Tipo de AMI
  }

  # Configuração dos grupos de nós gerenciados pelo EKS
  eks_managed_node_groups = {
    default = {
      name           = "node-group-1"  # Nome do grupo de nós
      instance_types = ["t3.small"]  # Tipo de instância
      min_size       = 1  # Tamanho mínimo do grupo
      max_size       = 5  # Tamanho máximo do grupo
      desired_size   = 3  # Tamanho desejado do grupo
    },
    additional = {
      name           = "node-group-2"  # Nome do grupo de nós adicional
      instance_types = ["t3.small"]  # Tipo de instância
      min_size       = 1  # Tamanho mínimo do grupo
      max_size       = 4  # Tamanho máximo do grupo
      desired_size   = 2  # Tamanho desejado do grupo
    }
  }
}
