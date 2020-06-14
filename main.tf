locals {
  public_ip  = google_compute_instance.pgbouncer.network_interface[0].network_ip
  private_ip = length(google_compute_instance.pgbouncer.network_interface[0].access_config) > 0 ? google_compute_instance.pgbouncer.network_interface[0].access_config[0].nat_ip : null
}

/* Instance Configuration --------------------------------------------------- */

locals {
  users    = [for u in var.users : ({ name = u.name, password = substr(u.password, 0, 2) == "md5" ? u.password : "md5${md5("${u.password}${u.name}")}" })]
  admins   = [for u in var.users : u.name if lookup(u, "admin", false) == true]
  userlist = templatefile("${path.module}/templates/userlist.txt.tmpl", { users = local.users })
  cloud_config = templatefile(
    "${path.module}/templates/pgbouncer.ini.tmpl",
    {
      db_host            = var.database_host
      db_port            = 5432 # it's not currently possible to customise the port used by Cloud SQL
      listen_port        = var.port
      auth_user          = var.auth_user
      auth_query         = var.auth_query
      default_pool_size  = var.default_pool_size
      max_db_connections = var.max_db_connections
      max_client_conn    = var.max_client_connections
      pool_mode          = var.pool_mode
      admin_users        = join(",", local.admins)
      custom_config      = var.pgbouncer_custom_config
    }
  )
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/cloud-init.yaml.tmpl")}"

  vars = {
    image       = "edoburu/pgbouncer:${var.pgbouncer_image_tag}"
    listen_port = var.port
    config      = base64encode(local.cloud_config)
    userlist    = base64encode(local.userlist)
  }
}

data "cloudinit_config" "cloud_config" {
  gzip          = false
  base64_encode = false
  part {
    filename     = "cloud-init.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_config.rendered
  }
}

data "google_compute_image" "boot" {
  project = split("/", var.boot_image)[0]
  family  = split("/", var.boot_image)[1]
}

resource "google_compute_instance" "pgbouncer" {
  project      = var.project
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags

  dynamic "service_account" {
    for_each = var.disable_service_account ? [] : [1]
    content {
      email  = var.service_account_email
      scopes = var.service_account_scopes
    }
  }

  metadata = {
    google-logging-enabled = var.disable_service_account ? null : true
    user-data              = data.cloudinit_config.cloud_config.rendered
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.boot.self_link
    }
  }

  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = var.project

    dynamic "access_config" {
      for_each = var.disable_public_ip ? [] : [1]
      content {
        nat_ip = var.public_ip_address
      }
    }
  }

  scheduling {
    automatic_restart = true
  }

  allow_stopping_for_update = true

  depends_on = [null_resource.module_depends_on]
}

/* Misc --------------------------------------------------------------------- */

# restart instance when users are updated, added or removed

resource "null_resource" "user_updater" {
  triggers = {
    users = join("", [for u in var.users : join("", values(u))])
  }
  provisioner "local-exec" {
    on_failure = continue
    command    = "gcloud compute instances reset --project '${var.project}' --zone '${var.zone}' '${google_compute_instance.pgbouncer.name}'"
  }
}

# inject external dependencies into module

resource "null_resource" "module_depends_on" {
  count = length(var.module_depends_on) > 0 ? 1 : 0

  triggers = {
    value = length(var.module_depends_on)
  }
}
