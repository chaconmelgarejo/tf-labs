# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: testing simple tf arch with modules
module "main-vpc" {
  source     = "../modules/vpc"
  env        = "prod"
  vm_region  = var.vm_region
}

module "instances" {
  source         = "../modules/instances"
  env            = "prod"
  my_vpc         = module.main-vpc.vpc_id
  public_subnets = module.main-vpc.public_subnets
}
