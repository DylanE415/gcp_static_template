terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "terraform-gcp-test-456122"
  region  = "us-central1"     
  credentials= "google_service_account_key.json"
}

provider "google-beta" {
  project = "terraform-gcp-test-456122"
  region  = "us-central1"
  credentials= "google_service_account_key.json"
}


#more info: https://registry.terraform.io/modules/gruntwork-io/static-assets/google/latest/submodules/cloud-storage-static-website?tab=inputs
module "static-assets_cloud-storage-static-website" {
  source  = "gruntwork-io/static-assets/google//modules/cloud-storage-static-website"
  version = "0.6.0"

  # insert the 2 required variables here
 
  project= "terraform-gcp-test-456122"
  website_domain_name= "static.foo.com"

}