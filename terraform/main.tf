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
  name     = var.bucket_name
  location = "US"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "site_src" {
  name   = "index.html"
  source = "../build/index.html"
  bucket = google_storage_bucket.site_bucket.name
}

# Remove this old block:
# resource "google_storage_object_access_control" "public_read" { … }

# Add this instead:
resource "google_storage_bucket_iam_binding" "public_read" {
  bucket = google_storage_bucket.site_bucket.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}
