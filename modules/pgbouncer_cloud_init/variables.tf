variable "database_host" {
  description = "The host address of the Cloud SQL instance to connect to."
  type        = string
}

variable "database_port" {
  description = "The port to connect to the database with."
  type        = number
  default     = 5432
}

variable "listen_port" {
  description = "The port used by PgBouncer to listen on."
  type        = number
}

variable "users" {
  description = "The list of users to be created in PgBouncer's userlist.txt. Passwords can be provided as plain-text or md5 hashes."
  type        = list
}

variable "auth_user" {
  description = "Any user not specified in `users` will be queried through the `auth_query` query from `pg_shadow` in the database, using `auth_user`. The user for `auth_user` must be included in `users`."
  type        = string
  default     = null
}

variable "auth_query" {
  description = "Query to load user’s password from database."
  type        = string
  default     = null
}

variable "pool_mode" {
  description = "Specifies when a server connection can be reused by other clients. Possible values are `session`, `transaction` or `statement`."
  type        = string
  default     = "transaction"
}

variable "default_pool_size" {
  description = "Maximum number of server connections to allow per user/database pair."
  type        = number
  default     = 20
}

variable "max_client_connections" {
  description = "Maximum number of client connections allowed."
  type        = number
  default     = 100
}

variable "max_db_connections" {
  description = "The maximum number of server connections per database (regardless of user). 0 is unlimited."
  type        = number
  default     = 0
}

variable "max_client_conn" {
  description = "The maximum number of server connections per database (regardless of user). 0 is unlimited."
  type        = number
  default     = 0
}

variable "custom_config" {
  description = "Custom PgBouncer configuration values to be appended to `pgbouncer.ini`."
  type        = string
  default     = ""
}

variable "pgbouncer_image_tag" {
  description = "The tag to use for the base PgBouncer `edoburu/pgbouncer` Docker image used by this module."
  default     = "latest"
}
