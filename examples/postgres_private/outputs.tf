output "instance_name" {
  description = "The name for the PgBouncer instance."
  value       = module.pgbouncer.instance_name
}

output "private_ip_address" {
  description = "The first private IPv4 address assigned to the PgBouncer instance."
  value       = module.pgbouncer.private_ip_address
}

output "public_ip_address" {
  description = "The first public IPv4 address assigned for the PgBouncer instance."
  value       = module.pgbouncer.public_ip_address
}

output "port" {
  description = "The port number PgBouncer listens on."
  value       = module.pgbouncer.port
}

output "database_url" {
  description = "The database URL for connecting to PgBouncer."
  value       = "postgres://${var.db_user}:${var.db_password}@${module.pgbouncer.public_ip_address}:${module.pgbouncer.port}/${var.db_name}"
  sensitive   = true
}
