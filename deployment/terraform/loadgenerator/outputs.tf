output "loadgenerator_vm_ip" {
  description = "The external IP address of the load generator VM"
  value       = google_compute_instance.loadgenerator.network_interface[0].access_config[0].nat_ip
}

output "private_key" {
  description = "The private SSH key"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}