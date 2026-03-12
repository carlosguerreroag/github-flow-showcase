# PROVIDER and BACKEND
# --------------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
#  backend "s3" {
#    bucket         = "tf-backend-yourname" 
#    key            = "main-account/terraform.tfstate"
#    region         = "your-region"
#    dynamodb_table = "tf-locks-yourname"
#    encrypt        = true
#  }
}

# REGION and CREDS
# --------------------------------------------------------------------
provider "aws" {
  region = var.main_aws_region
  access_key = var.aws_access_key 
  secret_key = var.aws_secret_key
}
