
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

### LOAD BALANCER PLUS CDN 


# 1. Reserve a global IPv4 address for your LB
resource "google_compute_global_address" "site_ip" {
  name = "${var.bucket_name}-ip"
}

# 2. Backend bucket (connects the LB → your GCS bucket) with CDN enabled
resource "google_compute_backend_bucket" "site_backend" {
  provider    = google-beta.beta
  name        = "${var.bucket_name}-backend"
  bucket_name = google_storage_bucket.site_bucket.name

  enable_cdn  = true

}





# 3. URL map → route ALL requests to the backend bucket and rewrite to /index.html
resource "google_compute_url_map" "site_url_map" {
  name            = "${var.bucket_name}-url-map"
  provider        = google-beta.beta    
  default_service = google_compute_backend_bucket.site_backend.id

  # Tell the URL-map which matcher handles all hosts
  host_rule {
    hosts        = ["*"]
    path_matcher = "root-and-assets"
  }

  # One matcher that
  #   • redirects exactly “/” → “/index.html” (301)
  #   • lets every other path fall through to the backend bucket
  path_matcher {
    name            = "root-and-assets"
    default_service = google_compute_backend_bucket.site_backend.id

    # Match ONLY the bare slash
    # rewrite only “/” to “/index.html” (no redirect)
    path_rule {
      paths = ["/"]                       # match the bare slash

      route_action {
        url_rewrite {
          path_prefix_rewrite = "/index.html"
          # ^ replaces the matched prefix “/” with “/index.html”
        }
      }
      # tell the LB what actually serves the request
      service = google_compute_backend_bucket.site_backend.id  
    }
  }
}



# 4. HTTP proxy → ties the URL map to the LB front-end on HTTP
resource "google_compute_target_http_proxy" "site_http_proxy" {
  name    = "${var.bucket_name}-http-proxy"
  url_map = google_compute_url_map.site_url_map.id
}


# 5. Forwarding rule → open port 80 on the reserved IP to the HTTP proxy
resource "google_compute_global_forwarding_rule" "site_fw" {
  name                  = "${var.bucket_name}-fw"
  ip_address            = google_compute_global_address.site_ip.address
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_http_proxy.site_http_proxy.id
}
