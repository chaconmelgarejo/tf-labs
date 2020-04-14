resource "google_compute_instance" "vm_instance" {
  project      = var.project_name
  name         = var.instance_name
  zone         = var.instance_zone
  machine_type = var.instance_type
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
      }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}