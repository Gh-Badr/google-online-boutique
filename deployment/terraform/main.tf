# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Changes made by Gh-Badr:
# - Removed code related to the app deployment
# - Removed code related to the Memorystore (redis) instance
# - Changed GKE cluster from autopilot to standard mode, and specified a custom configuration
# - Changed location from region to zone

# Definition of local variables
locals {
  base_apis = [
    "container.googleapis.com",
    "monitoring.googleapis.com",
    "cloudtrace.googleapis.com",
    "cloudprofiler.googleapis.com"
  ]
}

# Enable Google Cloud APIs
module "enable_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 17.0"

  project_id                  = var.gcp_project_id
  disable_services_on_destroy = false

  # activate_apis is the set of base_apis
  activate_apis = local.base_apis
}

# Create GKE cluster
resource "google_container_cluster" "my_cluster" {
  name     = var.name
  location = var.zone

  # Standard mode configuration
  initial_node_count = 4
  node_config {
    machine_type = "e2-standard-2"
  }
  
  # Disable deletion protection
  deletion_protection = false

  depends_on = [
    module.enable_google_apis
  ]
}