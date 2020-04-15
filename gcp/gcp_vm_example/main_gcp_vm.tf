# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: create with tf simple vm using backend & vars on gcp

resource "google_compute_instance" "gce_instance" {
  project      = var.project_name
  name         = var.vm_name
  machine_type = var.vm_type
  boot_disk {
    initialize_params {
      image = var.vm_image
      }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}