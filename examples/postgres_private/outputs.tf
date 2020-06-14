output "instance_name" {
  value = module.pgbouncer.instance_name
}

output "private_ip" {
  value = module.pgbouncer.private_ip_address
}

output "public_ip" {
  value = module.pgbouncer.public_ip_address
}

output "port" {
  value = module.pgbouncer.port
}

output "database_name" {
  value = var.db_name
}

output "username" {
  value = var.db_user
}

output "password" {
  value     = var.db_password
  sensitive = true
}

output "database_url" {
  value     = "postgres://${var.db_user}:${var.db_password}@${module.pgbouncer.public_ip_address}:${module.pgbouncer.port}/${var.db_name}"
  sensitive = true
}
