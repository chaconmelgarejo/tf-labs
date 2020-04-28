# tf-labs
# create with good vibes by: @chaconmelgarejo
# description: gcp labs - testing templates & groups for vm

provider "google" {
  region  = var.vm_region
  zone    = var.vm_zone
  project = var.project_name
}
