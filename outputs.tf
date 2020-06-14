output "instance_name" {
  description = "The instance name for the PgBouncer instance."
  value       = var.name
}

output "private_ip_address" {
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance."
  value       = local.private_ip
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance."
  value       = local.public_ip
}

output "port" {
  description = "The port number PgBouncer listens on."
  value       = var.port
}
