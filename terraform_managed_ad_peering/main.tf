resource "google_compute_network" "vpc-a" {
  name                    = var.vpc_a_name
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  mtu                     = var.mtu
  project                 = var.project_a_id
}

resource "google_compute_subnetwork" "vpc-a-subnet-a" {
  name          = var.vpc_a_subnet_name
  ip_cidr_range = var.vpc_a_subnet_cidr
  region        = var.vpc_a_subnet_region
  network       = google_compute_network.vpc-a.id
  project       = var.project_a_id
}

resource "google_compute_network" "vpc-b" {
  name                    = var.vpc_b_name
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  mtu                     = var.mtu
  project                 = var.project_b_id
}

resource "google_compute_subnetwork" "vpc-b-subnet-b" {
  name          = var.vpc_b_subnet_name
  ip_cidr_range = var.vpc_b_subnet_cidr
  region        = var.vpc_b_subnet_region
  network       = google_compute_network.vpc-b.id
  project       = var.project_b_id
}
# Active Directory Config
resource "google_active_directory_domain" "domain-a" {
  domain_name         = "domaina.lan"
  locations           = [var.vpc_a_subnet_region]
  reserved_ip_range   = "192.168.10.0/24"
  authorized_networks = tolist([google_compute_network.vpc-a.id])
  project             = var.project_a_id

  labels = {
    "peer_name" = var.ad_peering_name_a
    "proj_a_id" = var.project_a_id
    "proj_b_id" = var.project_b_id
  }

  provisioner "local-exec" {
    command = "gcloud active-directory peerings create ${var.ad_peering_name_a} --domain=${google_active_directory_domain.domain-a.name} --authorized-network=${google_compute_network.vpc-b.id} --project=${var.project_a_id}"
  }

  provisioner "local-exec" {
    command = "gcloud active-directory peerings create ${var.ad_peering_name_a} --domain=${google_active_directory_domain.domain-a.name} --authorized-network=${google_compute_network.vpc-b.id} --project=${var.project_b_id}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "gcloud active-directory peerings delete ${self.labels.peer_name} --project=${self.labels.proj_a_id} --quiet"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "gcloud active-directory peerings delete ${self.labels.peer_name} --project=${self.labels.proj_b_id} --quiet"
  }
}

resource "google_active_directory_domain" "domain-b" {
  domain_name         = "domainb.lan"
  locations           = ["us-central1"]
  reserved_ip_range   = "192.168.15.0/24"
  authorized_networks = tolist([google_compute_network.vpc-b.id])
  project             = var.project_b_id

  labels = {
    "peer_name" = var.ad_peering_name_b
    "proj_a_id" = var.project_a_id
    "proj_b_id" = var.project_b_id
  }

  provisioner "local-exec" {
    command = "gcloud active-directory peerings create ${var.ad_peering_name_b} --domain=${google_active_directory_domain.domain-b.name} --authorized-network=${google_compute_network.vpc-a.id} --project=${var.project_b_id}"
  }

  provisioner "local-exec" {
    command = "gcloud active-directory peerings create ${var.ad_peering_name_b} --domain=${google_active_directory_domain.domain-b.name} --authorized-network=${google_compute_network.vpc-a.id} --project=${var.project_a_id}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "gcloud active-directory peerings delete ${self.labels.peer_name} --project=${self.labels.proj_b_id} --quiet"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "gcloud active-directory peerings delete ${self.labels.peer_name} --project=${self.labels.proj_a_id} --quiet"
  }
}
