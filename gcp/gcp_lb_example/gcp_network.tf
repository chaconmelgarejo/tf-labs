# tf-labs
# create with good vibes by: @chaconmelgarejo
# description: gcp labs - testing templates & groups for vm


#create the vpc
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

#create subnets
resource "google_compute_subnetwork" "subnets" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_range
  region        = var.vm_region
  network       = google_compute_network.vpc.self_link

}


# create fw rule for webservers
resource "google_compute_firewall" "fw_rule_web" {
  name    = "web-fw-rule"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["webserver","http-server"]
}

# create fw rule for healthchecks
resource "google_compute_firewall" "fw_rule_hc" {
  ## firewall rules enabling the load balancer health checks
  name    = "hc-fw-rule"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
  target_tags   = ["webserver","http-server"]
}

# create the healthcheck
resource "google_compute_health_check" "hc-lb" {
  name                = "web-hc"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}


#create the BE service
resource "google_compute_backend_service" "web-be" {
  name      = "be-service"
  port_name = "http"
  protocol  = "HTTP"

  backend {
    group = google_compute_instance_group_manager.web-igm.instance_group
  }

  backend {
    group = google_compute_instance_group_manager.web-igm-slave.instance_group
  }

  health_checks = [
    google_compute_health_check.hc-lb.self_link,
  ]
}

# creating the FE Service & LB
resource "google_compute_url_map" "default" {
  name = "load-balancer"
  default_service = google_compute_backend_service.web-be.self_link
}

# create static ip
resource "google_compute_global_address" "static_ip" {
  name = "web-ip"
}


resource "google_compute_target_http_proxy" "default" {
  name = "http-proxy"
  url_map = google_compute_url_map.default.self_link
}

# creating global forwarding_rule
resource "google_compute_global_forwarding_rule" "default" {
  name = "forward-rule"
  target = google_compute_target_http_proxy.default.self_link
  ip_address = google_compute_global_address.static_ip.address
  port_range = "80"
}

##################################################################################
# OUTPUT
##################################################################################

output "gcp_ip_static" {
  value = google_compute_global_address.static_ip.address
}
