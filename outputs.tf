output "instance_name" {
  value = var.name
}

output "private_ip_address" {
  value = local.private_ip
}

output "public_ip_address" {
  value = local.public_ip
}

output "port" {
  value = var.port
}
