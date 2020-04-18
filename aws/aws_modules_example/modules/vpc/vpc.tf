# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: testing simple tf arch with modules
module "main-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-${var.env}"
  cidr = "10.55.0.0/16"

  azs             = ["${var.vm_region}a", "${var.vm_region}b", "${var.vm_region}c"]
  private_subnets = ["10.55.111.0/24", "10.55.112.0/24", "10.55.113.0/24"]
  public_subnets  = ["10.55.221.0/24", "10.55.222.0/24", "10.55.223.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.main-vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.main-vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.main-vpc.public_subnets
}

