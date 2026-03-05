# -------------------------------------------------
# ----------------- BACKEND -----------------------
# -------------------------------------------------
module "tf_s3_backend" {
  source        = "../../modules/bootstrap"
  bucket_name   = var.tf_backend_s3_bucket_name
  dynamodb_locks_table_name = var.tf_backend_lock_table_name
}

# -------------------------------------------------
# ----------------- SECURITY GROUPS ---------------
# -------------------------------------------------
locals {
  sg_rules = jsondecode(
    file(var.sg_commonports_rules)
  )
}

resource "aws_security_group" "sg_commonports" {
  name        = "commonPorts" 
  description = "Open common ports"
  vpc_id      = var.main_vpc_id
  tags        = {
    Project = "Devops"
    TerraformManaged = "true"
  }

  dynamic "ingress" {
    for_each = local.sg_rules.ingress
    content {
      description = try(ingress.value.desc, null)
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.proto
      cidr_blocks = ingress.value.cidrs
    }
  }
  dynamic "egress" {
    for_each = local.sg_rules.egress
    content {
      description = try(egress.value.desc, null)
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.proto
      cidr_blocks = egress.value.cidrs
    }
  }
}

# -------------------------------------------------
# ----------------- KEYPAIRS ----------------------
# -------------------------------------------------
resource "aws_key_pair" "personal" {
  key_name   = "personal"
  public_key = file("~/.ssh/id_rsa.pub")
}

# -------------------------------------------------
# ----------------- EC2 INSTANCES -----------------
# -------------------------------------------------
resource "aws_instance" "ec2_instance" {
  ami           = var.amis["ubuntu_240404"] 
  instance_type = "t3.micro"
  key_name      = "personal" 
  vpc_security_group_ids = [
    aws_security_group.sg_commonports.id,
  ]
  tags = {
    Project = "Devops"
    TerraformManaged = "true"
    Name = "app01"
  }
}

# -------------------------------------------------
# ----------------- ECR ---------------------------
# -------------------------------------------------
resource "aws_ecr_repository" "app01_registry" {
  name = "app01"
  image_tag_mutability = "IMMUTABLE" 

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = "prod" 
    TerraformManaged = "true"
    Project = "DevOps"
  }
}

resource "aws_ecr_lifecycle_policy" "app01_lifecycle" {
  repository = "app01" 

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# -------------------------------------------------
# ----------------- IAM POLICIES ------------------
# -------------------------------------------------
resource "aws_iam_policy" "github_actions_ecr_policy" {
  name        = "github-actions-ecr-policy"
  description = "ECR policy permissions for GH Actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = aws_ecr_repository.app01_registry.arn
      }
    ]
  })
}

# -------------------------------------------------
# ----------------- IAM USERS ---------------------
# -------------------------------------------------
resource "aws_iam_user" "github_actions" {
  name = "github-actions"
  tags = {
    TerraformManaged = "true"
    Project = "DevOps"
  }
}
resource "aws_iam_user_policy_attachment" "github_actions_attach" {
  user       = aws_iam_user.github_actions.name
  policy_arn = aws_iam_policy.github_actions_ecr_policy.arn
}
resource "aws_iam_access_key" "github_actions_key" {
  user = aws_iam_user.github_actions.name
}
