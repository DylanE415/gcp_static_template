
output "site_url" {
  description = "Your site is now available at this IP over HTTP"
  value       = "http://${google_compute_global_address.site_ip.address}"
}

output "website_url" {
  description = "Direct GCS website URL (virtual‑hosted) for your bucket"
  value       = "https://${google_storage_bucket.site_bucket.name}.storage.googleapis.com"
}