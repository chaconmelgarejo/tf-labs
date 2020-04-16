# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: create with tf simple cluster k8s
provider "google" {
    region  = var.cluster_region
    zone    = var.cluster_zone
}

provider "google-beta" {
    region  = var.cluster_region
    zone    = var.cluster_zone
}