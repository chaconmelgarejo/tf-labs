# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: create with tf simple vm using azure

variable "rg_name" {
    default = "test-rg"
}

variable "region" {
    default = "West US"
}

variable "network" {
    default = "10.0.0.0/16"
}

variable "network_name" {
    default = "test-network"
}

variable "subnet_private" {
    default = "10.0.2.0/24"
}

variable "subnet_private_name" {
    default = "test-subnet"
}

variable "prefix" {
  default = "dev"
}

variable "hostname" {
    default = "dev-server"
}

variable "username" {
    default = "testadmin"
}

variable "pass" {
    default = "Password1234!"
}