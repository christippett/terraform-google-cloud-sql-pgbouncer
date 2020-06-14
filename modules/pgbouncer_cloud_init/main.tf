locals {
  users    = [for u in var.users : ({ name = u.name, password = substr(u.password, 0, 2) == "md5" ? u.password : "md5${md5("${u.password}${u.name}")}" })]
  admins   = [for u in var.users : u.name if lookup(u, "admin", false) == true]
  userlist = templatefile("${path.module}/templates/userlist.txt.tmpl", { users = local.users })
  cloud_config = templatefile(
    "${path.module}/templates/pgbouncer.ini.tmpl",
    {
      db_host            = var.database_host
      db_port            = var.database_port
      listen_port        = var.listen_port
      auth_user          = var.auth_user
      auth_query         = var.auth_query
      default_pool_size  = var.default_pool_size
      max_db_connections = var.max_db_connections
      max_client_conn    = var.max_client_conn
      pool_mode          = var.pool_mode
      admin_users        = join(",", local.admins)
      custom_config      = var.custom_config
    }
  )
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/cloud-init.yaml.tmpl")}"
  vars = {
    image       = "edoburu/pgbouncer:${var.pgbouncer_image_tag}"
    listen_port = var.listen_port
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
