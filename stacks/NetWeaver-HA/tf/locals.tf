locals {
  ascs_health_check = {
    type                = "tcp"
    check_interval_sec  = 10
    healthy_threshold   = 4
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = var.ascs_health_check_port
    port_name           = "health-check-port"
    request             = ""
    request_path        = "/"
    host                = ""
  }
  ers_health_check = {
    type                = "tcp"
    check_interval_sec  = 10
    healthy_threshold   = 4
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = var.ers_health_check_port
    port_name           = "health-check-port"
    request             = ""
    request_path        = "/"
    host                = ""
  }
  ilb_required       = var.source_image_project == "rhel-sap-cloud" ? false : true
  region             = join("-", slice(split("-", var.primary_zone), 0, 2))
  subnetwork_project = var.subnetwork_project == "" ? var.project_id : var.subnetwork_project
  network_parts_hana = split("/", data.google_compute_subnetwork.subnetwork_hana.network)
  network_hana       = element(local.network_parts_hana, length(local.network_parts_hana) - 1)
  network_parts_nw   = split("/", data.google_compute_subnetwork.subnetwork_nw.network)
  network_nw         = element(local.network_parts_nw, length(local.network_parts_nw) - 1)
}
