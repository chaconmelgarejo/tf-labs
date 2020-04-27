# tf-labs
# create with good vibes by: @chaconmelgarejo
# description: gcp labs - testing templates & groups for vm

locals {
  project       = var.project_name
}


resource "google_compute_subnetwork" "subnet01" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_range
  region        = var.vm_region
  network       = google_compute_network.our_vpc.self_link


}

resource "google_compute_network" "our_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false

}

resource "google_compute_firewall" "default" {
  name    = "web-firewall"
  network = google_compute_network.our_vpc.name
  project       = var.project_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["webserver","http-server"]
}
