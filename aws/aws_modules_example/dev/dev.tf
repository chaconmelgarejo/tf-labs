# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: testing simple tf arch with modulesmodule "main-vpc" {
  source     = "../modules/vpc"
  env        = "dev"
  vm_region  = var.vm_region
}

module "instances" {
  source         = "../modules/instances"
  env            = "dev"
  my_vpc         = module.main-vpc.vpc_id
  public_subnets = module.main-vpc.public_subnets
}

