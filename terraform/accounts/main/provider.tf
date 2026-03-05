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
    bucket         = "tf-backend-carlosguerreroag" 
    key            = "main-account/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tf-locks"
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
