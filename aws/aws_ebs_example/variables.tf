# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: my ebs lab

variable "vm_type" {
  default = "t2.micro"
}
variable "ami" {
    default = "ami-07ebfd5b3428b6f4d"
}		  

variable "vm_zone" {
    default = "us-east-1a"
}

variable "subnet" {}

variable "mykey" {}
