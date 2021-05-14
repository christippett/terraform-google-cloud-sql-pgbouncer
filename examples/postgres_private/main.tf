provider "google" {}

provider "google-beta" {}

locals {
  region = join("-", slice(split("-", var.zone), 0, 2))
}

resource "random_id" "suffix" {
  byte_length = 5
}

data "google_compute_subnetwork" "subnet" {
  project = var.project
  name    = var.subnetwork_name
  region  = local.region
}

/* Database ----------------------------------------------------------------- */

module "private_service_access" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version = "~>5.0.0"

  project_id  = var.project
  vpc_network = var.network_name
}

module "db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~>5.0.0"

  project_id = var.project
  name       = "db-${random_id.suffix.hex}"

  database_version = "POSTGRES_12"
  region           = local.region
  zone             = split("-", var.zone)[2]
  tier             = "db-f1-micro"

  db_name       = var.db_name
  user_name     = var.db_user
  user_password = var.db_password

  ip_configuration = {
    ipv4_enabled        = false
    private_network     = data.google_compute_subnetwork.subnet.network
    require_ssl         = false
    authorized_networks = []
  }

  module_depends_on = [module.private_service_access.peering_completed]
}

/* PgBouncer ---------------------------------------------------------------- */

resource "google_compute_address" "pgbouncer" {
  project      = var.project
  region       = local.region
  name         = "ip-pgbouncer-${random_id.suffix.hex}"
  network_tier = "PREMIUM"
}

module "pgbouncer" {
  source = "../.."

  project           = var.project
  name              = "vm-pgbouncer-${random_id.suffix.hex}"
  zone              = var.zone
  subnetwork        = var.subnetwork_name
  public_ip_address = google_compute_address.pgbouncer.address
  tags              = ["pgbouncer"]

  disable_service_account = true

  port          = 25128
  database_host = module.db.private_ip_address

  users = [
    { name = var.db_user, password = var.db_password },
  ]

  module_depends_on = [module.db]
}

/* Firewall ----------------------------------------------------------------- */

resource "google_compute_firewall" "pgbouncer" {
  name    = "${var.network_name}-ingress-pgbouncer-${random_id.suffix.hex}"
  project = var.project
  network = var.network_name

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["pgbouncer"]

  allow {
    protocol = "tcp"
    ports    = [module.pgbouncer.port]
  }
}
