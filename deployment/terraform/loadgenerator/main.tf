resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_compute_instance" "locust_master" {
  count        = var.num_masters
  name         = "locust-master-${count.index}"
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

  tags = ["locust-master"]
}

resource "google_compute_instance" "locust_worker" {
  count        = var.num_workers
  name         = "locust-worker-${count.index}"
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
}

# Add the generated public key to the project metadata
resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "${var.username}:${tls_private_key.ssh_key.public_key_openssh}"
  }
}

# Allow traffic to the Locust master instance
resource "google_compute_firewall" "allow_locust" {
  name    = "allow-locust"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["8089", "5557", "9646"]
  }

  target_tags = ["locust-master"]
  source_ranges = ["0.0.0.0/0"]
}