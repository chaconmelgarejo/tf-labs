# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: testing simple tf arch with modules
variable "env" {}

variable "vm_type" {
  default = "t2.micro"
}
variable "ami" {
    default = "ami-07ebfd5b3428b6f4d"
}		  

variable "public_subnets" {}

variable "my_vpc" {}

variable "path_key" {
  default = "mykey.pub"
}