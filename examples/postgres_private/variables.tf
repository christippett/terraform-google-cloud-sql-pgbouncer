variable "project" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "zone" {
  description = "The zone where PgBouncer will be created."
  type        = string
}

variable "network_name" {
  description = "The name of the network where PgBouncer will be created."
  type        = string
}

variable "subnetwork_name" {
  description = "The name of the subnet where PgBouncer will be created."
  type        = string
}

variable "db_name" {
  description = "The name of the default database to create."
  default     = "defaultdb"
}

variable "db_user" {
  description = "The name of the default database user account."
  type        = string
}

variable "db_password" {
  description = "The password of the default database user account."
  type        = string
}
