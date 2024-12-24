output "locust_master_ips" {
  description = "The external IP addresses of the Locust master VMs"
  value       = [for instance in google_compute_instance.locust_master : instance.network_interface[0].access_config[0].nat_ip]
}

output "locust_worker_ips" {
  description = "The external IP addresses of the Locust worker VMs"
  value       = [for instance in google_compute_instance.locust_worker : instance.network_interface[0].access_config[0].nat_ip]
}

output "private_key" {
  description = "The private SSH key"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}