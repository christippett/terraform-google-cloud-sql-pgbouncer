provider "google" {
  region = "us-central1"
  zone   = "us-central1-a"
}

provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-a"
}

resource "random_id" "suffix" {
  byte_length = 5
}

/* Network ------------------------------------------------------------------ */

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.3"

  project_id   = var.project
  network_name = "vpc-${random_id.suffix.hex}"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-central1"
    }
  ]
}

module "private_service_access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  project_id  = var.project
  vpc_network = module.network.network_name
}

/* Database ----------------------------------------------------------------- */

module "db" {
  source = "GoogleCloudPlatform/sql-db/google//modules/postgresql"

  project_id = var.project
  name       = "db-${random_id.suffix.hex}"

  database_version = "POSTGRES_12"
  region           = "us-central1"
  zone             = "a"
  tier             = "db-f1-micro"

  db_name       = var.db_name
  user_name     = var.db_user
  user_password = var.db_password

  ip_configuration = {
    ipv4_enabled        = false
    private_network     = module.network.network_self_link
    require_ssl         = false
    authorized_networks = []
  }

  module_depends_on = [module.private_service_access.peering_completed]
}

/* PgBouncer ---------------------------------------------------------------- */

resource "google_compute_address" "pgbouncer" {
  project      = var.project
  name         = "ip-pgbouncer-${random_id.suffix.hex}"
  network_tier = "PREMIUM"
}

module "pgbouncer" {
  source = "../.."

  project           = var.project
  name              = "vm-pgbouncer-${random_id.suffix.hex}"
  zone              = "us-central1-a"
  subnetwork        = "subnet-01"
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
  name    = "fw-pgbouncer-${random_id.suffix.hex}"
  project = var.project
  network = module.network.network_self_link

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["pgbouncer"]

  allow {
    protocol = "tcp"
    ports    = [module.pgbouncer.port, 22]
  }
}
