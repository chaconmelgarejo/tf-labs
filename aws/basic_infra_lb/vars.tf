variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {}
variable "region" {
  default = "sa-east-1"
}
variable "network_cidr" {
  default = "10.16.0.0/16"
}
variable "subnet1_range" {
  default = "10.16.0.0/24"
}
variable "subnet2_range" {
  default = "10.16.1.0/24"
}
variable "bucket_name" {}
variable "billing_tag" {}
variable "env_tag" {}
variable "vm_type" {
  default = "t2.micro"
}


# locals vars
locals {
  common_tags = {
    BillingCode = var.billing_tag
    Env = var.env_tag
  }

}

# data sources

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["instance-store"]
  }
}
