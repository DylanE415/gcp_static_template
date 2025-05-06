
output "site_url" {
  description = "Your site is now available at this IP over HTTP"
  value       = "http://${google_compute_global_address.site_ip.address}"
}
