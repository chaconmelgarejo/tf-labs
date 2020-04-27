# tf-labs
# create with good vibes by: @chaconmelgarejo
# description: gcp labs - testing templates & groups for vm

variable "project_name" {
  default = "default"
}

variable "vm_name" {
  default = "webserver"
}

variable "vm_zone" {
  default = "us-central1-b"
}

variable "vm_type" {
  default = "f1-micro"
}

variable "vm_image" {
  default = "debian-cloud/debian-9"
}

variable "vm_region" {
  default = "us-central1"
}

variable "vpc_name" {
  default = "web-vpc"
}

variable "subnet_name" {
  default = "web-subnet"
}

variable "subnet_range" {
  default = "10.16.10.0/24"
}

variable "gs_script" {
  default = "gs://my-laboratorio-web/ubuntu_web.sh"
}
