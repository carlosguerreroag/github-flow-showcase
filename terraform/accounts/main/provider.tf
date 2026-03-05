# PROVIDER and BACKEND
# --------------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = modules.tf_s3_backend.s3_bucket_name
    key            = "main-account/terraform.tfstate"
    region         = var.main_aws_region
    dynamodb_table = modules.tf_s3_backend.dynamodb_table_name
    encrypt        = true
  }
}

# REGION and CREDS
# --------------------------------------------------------------------
provider "aws" {
  region = var.main_aws_region
  access_key = var.aws_access_key 
  secret_key = var.aws_secret_key
}
