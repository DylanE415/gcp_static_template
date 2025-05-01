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
    not_found_page   = "index.html"
  }

  uniform_bucket_level_access = true
}



resource "google_storage_bucket_iam_binding" "public_read" {
  bucket = google_storage_bucket.site_bucket.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

# Redirect  /<bucket-name>/index.html  →  /
resource "google_storage_bucket_object" "root_index_redirect" {
  bucket = google_storage_bucket.site_bucket.name

  # Object key is  <bucket-name>/index.html
  # (exactly what the browser requests after the leading slash)
  name   = "${google_storage_bucket.site_bucket.name}/index.html"

  content          = ""              # Empty placeholder
  content_type     = "text/html"
  website_redirect = "/"             # 301 Location: /
}
  #
