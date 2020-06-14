variable "project" {
  description = "The ID of the project in which to provision resources."
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
