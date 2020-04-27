# tf-labs
# create with good vibes by: @chaconmelgarejo
# description: gcp labs - testing templates & groups for vm

resource "google_compute_instance_template" "default" {
  name        = var.vm_name
  project     = var.project_name
  description = "This template is used to create app server instances."

  tags = ["webserver", "http-server"]

  labels = {
    environment = "dev",
    app="web"
  }

  instance_description = "description assigned to instances"
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
    subnetwork = google_compute_subnetwork.subnet01.self_link
    access_config {}
  }


  metadata = {
    foo = "bar"
    metadata_startup_script = var.gs_script
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}



resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds
  project = var.project_name

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

resource "google_compute_instance_group_manager" "appserver" {
  name = "webserver-igm"
  project = var.project_name

  base_instance_name = "app"
  zone               = var.vm_zone

  version {
    instance_template  = google_compute_instance_template.default.self_link
  }

  #target_pools = [google_compute_target_pool.appserver.self_link]
  target_size  = 2



  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.self_link
    initial_delay_sec = 300
  }
}
