resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_compute_instance" "loadgenerator" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "${var.image_project}/${var.image_family}"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      // Ephemeral public IP
    }
  }

  tags = var.tags
}

# Add the generated public key to the project metadata
resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "${var.username}:${tls_private_key.ssh_key.public_key_openssh}"
  }
}