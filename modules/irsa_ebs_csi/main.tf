# Define o recurso do IAM Role
resource "aws_iam_role" "this" {
  name = "ebs-csi-role"  # Nome do IAM Role

  assume_role_policy = jsonencode({  # Política que define quem pode assumir este role
    Version = "2012-10-17"  # Versão da política
    Statement = [
      {
        Effect = "Allow"  # Permite que o EKS assuma este role
        Principal = {
          Service = "eks.amazonaws.com"  # Serviço que pode assumir o role
        }
        Action = "sts:AssumeRole"  # Ação permitida
      },
    ]
  })
}

# Define a política do IAM Policy
resource "aws_iam_policy" "ebs_csi_policy" {
  name        = "ebs-csi-policy"  # Nome da política
  description = "Policy for EBS CSI driver"  # Descrição da política
  policy = jsonencode({  # Conteúdo da política em formato JSON
    Version = "2012-10-17"  # Versão da política
    Statement = [
      {
        Effect = "Allow"  # Permissão concedida
        Action = [  # Ações permitidas na política
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:DeleteSnapshot",
          "ec2:Describe*",
          "ec2:DetachVolume"
        ]
        Resource = "*"  # Recursos aos quais a política se aplica
      },
    ]
  })
}

# Anexa a política IAM ao role
resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
  role       = aws_iam_role.this.name  # Nome do role ao qual a política será anexada
  policy_arn = aws_iam_policy.ebs_csi_policy.arn  # ARN da política a ser anexada
}

# Saída do ARN do IAM Role
output "iam_role_arn" {
  value = aws_iam_role.this.arn  # Valor de saída que será o ARN do role
}
