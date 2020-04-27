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

resource "google_compute_backend_service" "staging_service" {
  name      = "dev-service"
  port_name = "http"
  protocol  = "HTTP"
  project = var.project_name

  backend {
    group = google_compute_instance_group_manager.appserver.instance_group
  }

  health_checks = [
    google_compute_health_check.autohealing.self_link,
  ]
}

resource "google_compute_global_address" "default" {
  name = "global-appserver-ip"
  project = var.project_name
}


resource "google_compute_global_forwarding_rule" "default" {
  name = "fw-rule"
  project = var.project_name
  target = google_compute_target_http_proxy.default.self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"
}

resource "google_compute_target_http_proxy" "default" {
  name = "http-proxy"
  project = var.project_name
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_url_map" "default" {
  name = "load-balancer"
  project       = var.project_name
  default_service = google_compute_backend_service.staging_service.self_link
}

# resource "google_compute_url_map" "default" {
#   name = "load-balancer"
#   description = "URL Map"
#   project = var.project_name
#   default_service = google_compute_backend_service.staging_service.self_link
#
#   host_rule {
#     hosts = [google_compute_global_address.default.address]
#     path_matcher = "allpaths"
#   }
#
#   path_matcher {
#     name            = "allpaths"
#     default_service = google_compute_backend_service.staging_service.self_link
#
#   path_rule {
#       paths   = ["/*"]
#       service = google_compute_backend_service.staging_service.self_link
#     }
#   }
#
# }
