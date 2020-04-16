# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: create with tf simple cluster k8s
variable "project_name" {
  default ="default"
}

variable "cluster_name" {
  default = "test-cluster"
}

variable "cluster_zone" {
  default = "us-central1-b"
}

variable "cluster_region" {
  default = "us-central1"
}
