
output "index_url" {
  description = "Public URL for the uploaded index.html"
  value       = "https://storage.googleapis.com/${google_storage_bucket.site_bucket.name}/index.html"
}
