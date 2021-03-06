/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "attached_disks" {
  value = google_compute_attached_disk.attached_disks
}

output "instance_self_link" {
  value = google_compute_instance.instance.self_link
}

output "internal_ip" {
  value = google_compute_address.internal_ip.address
}

output "network" {
  value = local.network
}

output "region" {
  value = local.region
}

output "subnetwork" {
  value = data.google_compute_subnetwork.subnetwork
}

output "subnetwork_project_id" {
  value = local.subnetwork_project_id
}
