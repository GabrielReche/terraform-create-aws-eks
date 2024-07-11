## Estrutura do Projeto

modules/irsa_ebs_csi/main.tf
addons.tf
main.tf
outputs.tf
terraform.tf
variables.tf

1. modules/irsa_ebs_csi/main.tf

Este módulo cria uma Role e uma Policy no IAM (Identity and Access Management) da AWS para o driver EBS CSI (Elastic Block Store Container Storage Interface). Isso permite que o driver EBS CSI no seu cluster EKS (Elastic Kubernetes Service) tenha as permissões necessárias para interagir com os volumes EBS.

Funções principais:

Criação de uma Role no IAM que permite ao EKS assumir a Role.
Definição de uma Policy que permite ao driver EBS CSI executar ações específicas no serviço EC2.
Anexação da Policy à Role criada.

## Informaçõoes para mudar em um novo projeto - main.tf

Nome da Role (aws_iam_role.this): Altere o nome da role conforme a convenção de nomenclatura do seu novo projeto.

Política (aws_iam_policy.ebs_csi_policy): Verifique e ajuste as permissões necessárias para o driver EBS CSI de acordo com os requisitos do seu novo ambiente.

Anexo de Política (aws_iam_role_policy_attachment.ebs_csi_attach): Verifique se o ARN da política e o nome da role estão corretos para o novo projeto.

2. addons.tf

Este arquivo define a instalação de vários add-ons no cluster EKS.

Funções principais:

Adiciona o add-on vpc-cni para gerenciamento de redes VPC.
Adiciona o add-on kube-proxy para proxy de rede no Kubernetes.
Adiciona o add-on coredns para resolução de DNS no cluster.
Adiciona o add-on aws-ebs-csi-driver para permitir que o cluster EKS use volumes EBS.

## Informaçõoes para mudar em um novo projeto - addons.tf

Add-ons: Verifique os add-ons necessários para o novo projeto e ajuste conforme necessário. Por exemplo, você pode precisar de add-ons específicos para segurança, monitoramento ou gerenciamento de recursos.

3. main.tf

Este é o arquivo principal onde a infraestrutura é definida.

Funções principais:

Configura o provider AWS e define a região.
Obtém as zonas de disponibilidade disponíveis na região especificada.
Cria uma string aleatória para ser usada como sufixo em recursos, garantindo nomes únicos.
Inclui o módulo irsa_ebs_csi para configurar o IRSA (IAM Roles for Service Accounts) para o driver EBS CSI.
Cria uma VPC usando o módulo terraform-aws-modules/vpc/aws.
Cria um cluster EKS usando o módulo terraform-aws-modules/eks/aws, incluindo a configuração de grupos de nós gerenciados.

## Informaçõoes para mudar em um novo projeto - main.tf

Provider AWS (provider "aws"): Atualize a região (region) para a região AWS desejada para o novo projeto.

Módulo IRSA EBS CSI (module "irsa_ebs_csi"): Certifique-se de definir as variáveis do módulo conforme necessário para o novo ambiente, como políticas de IAM específicas ou outras configurações.

Módulo VPC (module "vpc"): Configure o módulo VPC com o bloco CIDR desejado para a nova VPC, as sub-redes públicas e privadas, e outras configurações de rede conforme o novo projeto requer.

Módulo EKS (module "eks"): Defina o nome do cluster, versão do EKS, tipos de instâncias, configurações de segurança e outros parâmetros conforme necessário para o novo ambiente.

4. outputs.tf

Este arquivo define as saídas do Terraform, que são valores que podem ser utilizados posteriormente.

Funções principais:

Exibe o endpoint do cluster EKS.
Exibe os IDs dos grupos de segurança do cluster.
Exibe a região da AWS utilizada.
Exibe o nome do cluster EKS.

## Informaçõoes para mudar em um novo projeto - outputs.tf

Saídas (output): Verifique e ajuste as saídas conforme as informações que você precisa acessar após a implantação do novo projeto, como endpoints, IDs de segurança, região, nome do cluster, etc.

5. terraform.tf

Este arquivo configura o Terraform e os providers necessários.

Funções principais:

Define os providers AWS, random, tls e cloudinit.
Especifica a versão mínima do Terraform que deve ser utilizada.

## Informaçõoes para mudar em um novo projeto - terraform.tf

Providers (required_providers): Verifique e atualize as versões dos providers conforme necessário para o novo projeto, garantindo compatibilidade com as versões mais recentes e estáveis.

6. variables.tf

Este arquivo define as variáveis que serão utilizadas em todo o projeto.

Funções principais:

Define variáveis para a região da AWS, tipos de logs habilitados, blocos CIDR para acesso ao endpoint do cluster, versão do EKS, nome do cluster, versões dos add-ons, configurações da VPC e outros parâmetros.

## Informaçõoes para mudar em um novo projeto - variables.tf

Variáveis (variable): Adicione ou remova variáveis conforme necessário para configurar o novo projeto. Certifique-se de definir variáveis para configurar a região, versões do EKS e add-ons, configurações da VPC, e outros parâmetros que precisam ser configurados de forma flexível.



# Estrutura e Nomes de Recursos do Projeto Terraform

Módulo IRSA EBS CSI (modules/irsa_ebs_csi/main.tf)

Role IAM:
    Nome: ebs-csi-role
    Política Anexada: Permissões para gerenciar volumes EBS (Attach, Detach, CreateSnapshot, DeleteSnapshot, Describe*).


Add-ons (addons.tf)
    AWS EKS Add-ons:

    VPC-CNI:

        Nome: vpc-cni
        ersão: v1.18.1-eksbuild.1

    Kube-Proxy:
        Nome: kube-proxy

    CoreDNS:
        Nome: coredns

    EBS CSI Driver:
        Nome: aws-ebs-csi-driver
        Versão: v1.32.0-eksbuild.1
        Role do Service Account: ebs-csi-role


Configuração Principal (main.tf)

VPC (module "vpc"):
    Nome: cluster-vpc
    CIDR da VPC: 10.0.0.0/16
    Sub-redes Privadas: ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    Sub-redes Públicas: ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    Gateways NAT: Habilitados, utilizando um único gateway para todas as sub-redes privadas.


EKS (module "eks"):
    Nome do Cluster: cluster-eks-nomedocliente
    Versão do EKS: 1.22
    Sub-redes: Sub-redes privadas da VPC cluster-vpc.
Node Groups:
    Node Group 1:
        Nome: node-group-1
        Tipo de Instância: t3.small
        Mínimo/Máximo/Desired Size: 1/5/3
Node Group 2:
    Nome: node-group-2
        Tipo de Instância: t3.small
        Mínimo/Máximo/Desired Size: 1/4/2


Saídas (outputs.tf)

Endpoint do Cluster EKS:
    Descrição: Endpoint para o plano de controle do EKS
    Valor: <endpoint do seu cluster>

ID do Grupo de Segurança do Cluster:
    Descrição: IDs dos grupos de segurança anexados ao plano de controle do cluster
    Valor: <IDs dos grupos de segurança>

Região AWS:
    escrição: Região da AWS onde o cluster EKS está implantado
    Valor: us-east-1

Nome do Cluster Kubernetes:
    Descrição: Nome do cluster EKS na AWS
    Valor: cluster-eks-nomedocliente


# Passos para Executar o Projeto na AWS:

1. Configuração Inicial:

Certifique-se de ter o Terraform instalado em sua máquina local.
Configure suas credenciais AWS localmente utilizando aws configure para autenticar o Terraform com a AWS.

2. Clone o Repositório:

Clone o repositório Git onde seus arquivos do Terraform estão armazenados localmente.

3. Inicialize o Diretório do Terraform:

Abra o terminal, navegue até o diretório onde estão seus arquivos do Terraform (main.tf, variables.tf, etc.).
Execute o comando terraform init para inicializar o diretório do Terraform. Isso baixará os plugins necessários e configurará seu ambiente.

4. Visualize as Mudanças Propostas (Opcional):

Execute terraform plan para ver uma prévia das alterações que o Terraform fará na sua infraestrutura AWS. Isso é útil para verificar se há erros ou configurações que precisam ser ajustadas.

5. Aplicar as Mudanças:

Execute terraform apply para aplicar as alterações definidas nos arquivos do Terraform à sua conta AWS. O Terraform solicitará sua confirmação antes de fazer qualquer alteração.

6. Aprovação do Plano:

Durante o terraform apply, o Terraform mostrará um resumo das mudanças planejadas. Digite yes quando solicitado para aplicar as mudanças.

7. Acompanhe o Progresso:

O Terraform começará a criar os recursos especificados (VPC, EKS cluster, etc.). Isso pode levar algum tempo, dependendo da complexidade do ambiente definido.

8. Verifique a Implantação:

Após a conclusão, o Terraform exibirá uma mensagem indicando que os recursos foram criados com sucesso.
Verifique no console da AWS se os recursos foram criados conforme esperado.

9. Gerenciar os Recursos:

Para gerenciar seus recursos no futuro (atualizações, destruição, etc.), use comandos Terraform como terraform apply, terraform destroy, etc., conforme necessário.


10. Observações Importantes:

Gerenciamento de Estado: O Terraform mantém um estado do ambiente implantado localmente. Certifique-se de guardar e gerenciar este estado de forma segura para evitar perda de dados ou alterações não autorizadas.

Segurança: Mantenha suas credenciais AWS seguras e evite compartilhá-las publicamente.

Monitoramento: Após a implantação, monitore seus recursos na AWS para garantir que tudo esteja funcionando conforme esperado e que não haja custos inesperados.
