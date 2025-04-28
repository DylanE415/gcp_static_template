terraform {
  required_version = ">= 1.5.0"   
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"          
    }
  }
}


resource "google_storage_bucket" "site_bucket" {
    name = var.bucket_name
    location = "US"
}

resource "google_storage_bucket_object" "site_src" {
    name = "index.html"
    source = "../build/index.html"
    bucket= google_storage_bucket.site_bucket.name
}

resource "google_storage_object_access_control" "public_read"{
    object= google_storage_bucket_object.site_src.name
    bucket = google_storage_bucket.site_bucket.name

    role = "READER"
    entity= "allUsers"

}