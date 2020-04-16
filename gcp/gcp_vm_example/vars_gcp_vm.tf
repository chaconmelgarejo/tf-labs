# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: create with tf simple vm using backend & vars on gcp
variable "project_name" {
  default ="default"
}

variable "vm_name" {
  default = "my-default-vm"
}

variable "vm_zone" {
  default = "us-west1-b"
}

variable "vm_type" {
  default = "f1-micro"
}

variable "vm_image" {
  default = "debian-cloud/debian-9"
}

variable "vm_region" {
  default = "us-west1"
}
