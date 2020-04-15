# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: define provider & backend conf
provider "google" {
    region  = var.vm_region
    zone    = var.vm_zone
}