# EC2
output "instance_id" {
  value = aws_instance.app01.id
}

output "public_ip" {
  value = aws_instance.app01.public_ip
}

# ECR
output "ecr_repository_url" {
  description = "ECR repository URL"
  value = aws_ecr_repository.app01_registry.repository_url
}
output "ecr_repository_arn" {
  description = "ECR repository ARN"
  value = aws_ecr_repository.app01_registry.arn
}
output "ecr_repository_name" {
  value = aws_ecr_repository.app01_registry.name
}

# IAM
### ACCESS KEYS
output "github_actions_aws_access_key_id" {
  description = "Access Key ID para GitHub Actions"
  value       = aws_iam_access_key.github_actions_key.id
  sensitive   = true
}

output "github_actions_aws_secret_access_key" {
  description = "Secret Access Key para GitHub Actions"
  value       = aws_iam_access_key.github_actions_key.secret
  sensitive   = true
}

# SECURITY GROUPS
output "id" {
  value = aws_security_group.sg_commonports.id
}

output "name" {
  value = aws_security_group.sg_commonports.name
}
