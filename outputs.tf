output "instance_name" {
  description = "The name for the PgBouncer instance."
  value       = var.name
}

output "private_ip_address" {
  description = "The first private IPv4 address assigned to the PgBouncer instance."
  value       = local.private_ip
}

output "public_ip_address" {
  description = "The first public IPv4 address assigned for the PgBouncer instance."
  value       = local.public_ip
}

output "port" {
  description = "The port number PgBouncer listens on."
  value       = var.port
}
