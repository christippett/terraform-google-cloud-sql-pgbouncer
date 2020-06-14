output "cloud_config" {
  description = "Cloud-init config to set up and serve PgBouncer."
  value       = data.cloudinit_config.cloud_config.rendered
}
