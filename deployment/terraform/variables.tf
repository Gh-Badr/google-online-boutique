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
# - Removed filepath_manifests and namespace variables related to the app deployment
# - Removed memorystore variable related to the Memorystore (redis) instance
# - Set default value of region variable to "europe-west6"
# - Added zone variable, and set default value to "europe-west6-b"

variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to apply this config to"
}

variable "name" {
  type        = string
  description = "Name given to the new GKE cluster"
  default     = "online-boutique"
}

variable "region" {
  type        = string
  description = "Region of the new GKE cluster"
  default     = "europe-west6"
}

variable "zone" {
  type        = string
  description = "Zone of the new GKE cluster"
  default     = "europe-west6-b"
}