# tf-labs
# create with good vibes by: @chaconmelgarejo
# description: gcp labs - testing templates & groups for vm


#check the AZ data
data "google_compute_zones" "available" {}

# creating instance template
resource "google_compute_instance_template" "web-it" {
  name        = var.vm_name
  tags = ["webserver", "http-server"]

  labels = {
    environment = "dev",
    app="web"
  }

  machine_type         = var.vm_type
  can_ip_forward       = false
  metadata_startup_script = var.gs_script

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = var.vm_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnets.self_link
    access_config {}
  }


  metadata = {
    metadata_startup_script = var.gs_script
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

# create instance group manage 01
resource "google_compute_instance_group_manager" "web-igm" {
  name                = "webserver-igm"
  base_instance_name  = "webserver"
  zone                = data.google_compute_zones.available.names[0]

  version {
    instance_template  = google_compute_instance_template.web-it.self_link
  }

  target_size  = 1

  auto_healing_policies {
    health_check      = google_compute_health_check.hc-lb.self_link
    initial_delay_sec = 300
  }
}

# create instance group manage 02
resource "google_compute_instance_group_manager" "web-igm-slave" {
  name                = "webserver-igm02"
  base_instance_name  = "webserver02"
  zone                = data.google_compute_zones.available.names[1]

  version {
    instance_template  = google_compute_instance_template.web-it.self_link
  }

  target_size  = 1

  auto_healing_policies {
    health_check      = google_compute_health_check.hc-lb.self_link
    initial_delay_sec = 300
  }
}
