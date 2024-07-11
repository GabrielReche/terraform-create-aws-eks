# Arquivo principal de configuração do Terraform

terraform {
  # Bloco que define os provedores necessários para o Terraform
  required_providers {
    # Provedor AWS para interagir com a infraestrutura na Amazon Web Services
    aws = {
      source  = "hashicorp/aws"  # Fonte do provedor AWS
      version = "~> 5.7.0"  # Versão do provedor AWS a ser usada
    }

    # Provedor Random para gerar strings aleatórias
    random = {
      source  = "hashicorp/random"  # Fonte do provedor Random
      version = "~> 3.5.1"  # Versão do provedor Random a ser usada
    }

    # Provedor TLS para gerenciar certificados TLS/SSL
    tls = {
      source  = "hashicorp/tls"  # Fonte do provedor TLS
      version = "~> 4.0.4"  # Versão do provedor TLS a ser usada
    }

    # Provedor CloudInit para inicialização de instâncias em nuvem
    cloudinit = {
      source  = "hashicorp/cloudinit"  # Fonte do provedor CloudInit
      version = "~> 2.3.2"  # Versão do provedor CloudInit a ser usada
    }
  }

  # Versão requerida do Terraform
  required_version = "~> 1.3"  # Especifica que qualquer versão 1.3.x do Terraform pode ser usada
}
