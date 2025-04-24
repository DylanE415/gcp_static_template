terraform {
  required_version = ">= 1.5.0"   
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"          
    }
  }
}


resource "google_storage_bucket" "democloudgo13r123" {
    name = "democloudgo"
    location = "US"
}

resource "google_storage_bucket_object" "site_src" {
    name = "index.html"
    source = "build/index.html"
    bucket= google_storage_bucket.democloudgo13r123.name
}

resource "google_storage_object_access_control" "public_read"{
    object= google_storage_bucket_object.site_src.name
    bucket = google_storage_bucket.democloudgo13r123.name

    role = "READER"
    entity= "allUsers"

}