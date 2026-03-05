# GLOBAL VARIABLES
variable "aws_secret_key" {
  sensitive = true
  type = string
}

variable "aws_access_key" {
  sensitive = true
  type = string
}

variable "main_vpc_id" {
  sensitive = true
  type = string
  default = null
}

variable "main_aws_region" {
  sensitive = true
  type = string
  default = "eu-west-1"
}

variable "amis" {
  type = map(string)
  default = {
    "ubuntu_240404" = "ami-03446a3af42c5e74e"
  }
}

variable "sg_commonports_rules" {
  type = string
  default = "../../files/security-groups/rules/commonports.json" 
}

variable "tf_backend_s3_bucket_name" {
  sensitive = true
  type = string
}

variable "tf_backend_locks_table_name" {
  sensitive = true
  type = string
}
