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

resource "google_compute_firewall" "hc-lb" {
  ## firewall rules enabling the load balancer health checks
  name    = "monitor-firewall"
  project       = var.project_name
  network = google_compute_network.our_vpc.name
  description = "allow Google health checks and network load balancers access"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["1337"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
  target_tags   = ["webserver","http-server"]
}
