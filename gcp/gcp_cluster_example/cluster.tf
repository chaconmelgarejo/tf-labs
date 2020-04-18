# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: create with tf simple cluster k8s using default node pool
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_zone
  project  = var.project_name
  master_authorized_networks_config {}

  network = var.cluster_network
  subnetwork = var.cluster_subnetwork
  logging_service = "logging.googleapis.com/kubernetes"

  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
   
   node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    
  }
  
}