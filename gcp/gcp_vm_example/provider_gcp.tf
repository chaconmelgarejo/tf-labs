provider "google" {
    region      = var.region
}

terraform {
  backend "gcs" {
    bucket  = "cs-infra"
    prefix  = "terraform/dev"
  }
}