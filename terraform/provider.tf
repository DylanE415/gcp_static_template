terraform {
  required_providers {
    google      = { source = "hashicorp/google"    ,  version = "~> 5.0" }
    google-beta = { source = "hashicorp/google-beta", version = "~> 5.0" }
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

provider "google-beta" {
  alias   = "beta"
  project = var.gcp_project
  region  = var.gcp_region
}
