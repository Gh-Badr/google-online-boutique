variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to apply this config to"
}

variable "region" {
  type        = string
  description = "Region of the VM"
  default     = "europe-west6"
}

variable "zone" {
  type        = string
  description = "Zone of the VM"
  default     = "europe-west6-b"
}

variable "vm_name" {
  type        = string
  description = "Name of the VM instance"
  default     = "loadgenerator-vm"
}

variable "machine_type" {
  type        = string
  description = "Machine type for the VM instance"
  default     = "e2-medium"
}

variable "image_family" {
  type        = string
  description = "Image family for the VM instance"
  default     = "ubuntu-2204-lts"
}

variable "image_project" {
  type        = string
  description = "Image project for the VM instance"
  default     = "ubuntu-os-cloud"
}

variable "network" {
  type        = string
  description = "Network for the VM instance"
  default     = "default"
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork for the VM instance"
  default     = "default"
}

variable "username" {
  type        = string
  description = "Username for the VM instance"
  default    = "root"
}

variable "num_masters" {
  type        = number
  description = "Number of Locust master instances"
  default     = 1
}

variable "num_workers" {
  type        = number
  description = "Number of Locust worker instances"
  default     = 3
}