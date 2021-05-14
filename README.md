# Terraform PgBouncer for Cloud SQL

[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/christippett/terraform-google-cloud-sql-pgbouncer?label=Version)](./CHANGELOG.md) [![Terraform Registry](https://img.shields.io/badge/Terraform-Registry-623CE4)](https://registry.terraform.io/modules/christippett/cloud-sql-pgbouncer/)

Let Cloud Run wild on your database 🐆

## Overview

This module creates a Compute Engine instance running PgBouncer that sits in front of a Cloud SQL or self-hosted PostgreSQL instance.

Refer to the [examples/](./examples/) sub-directory for a complete example of how this module can be integrated and used with Cloud SQL.

```hcl
module "pgbouncer" {
  source  = "christippett/cloud-sql-pgbouncer/google"
  version = "~>1.2"

  project      = var.project
  name         = "pgbouncer"
  zone         = "us-central1-a"
  subnetwork   = "subnet-1"
  machine_type = "f1-micro"

  port          = 25128
  database_host = 5432

  users = [
    { name = "admin", password = "password", admin = true },
    { name = "user", password = "md55f4dcc3b5aa765d61d8327deb882cf99" }
  ]
}
```

## Authentication

The module accepts both plain-text or pre-hashed md5 passwords as input. Plain-text passwords will be automatically hashed to md5 and their hashed values stored in Terraform's state.

The `users` map accepts an optional `admin` key. When this is set to `true`, the user will be added to the list of PgBouncer admins and stats users.

## Configuring PgBouncer

Only a subset of PgBouncer's configuration are exposed as input variables. If you wish to customise PgBouncer further, you're able to provide your own configuration via the `pgbouncer_custom_config` input variable (type `map(string)`). The values from this variable will be added to `pgbouncer.ini`.

The `pgbouncer.ini` template used by this module can be found [here](./modules/pgbouncer_cloud_init/templates/pgbouncer.ini.tmpl). Refer to the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for a full list of configuration options.

## Inputs

| Name                    | Description                                                                                                                                                                                 | Type     | Default                  | Required |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------ | :------: |
| database_host           | The host address of the Cloud SQL instance to connect to.                                                                                                                                   | `string` | n/a                      |   yes    |
| name                    | The name of the PgBouncer instance.                                                                                                                                                         | `string` | n/a                      |   yes    |
| port                    | The port used by PgBouncer to listen on.                                                                                                                                                    | `number` | n/a                      |   yes    |
| project                 | The ID of the project where PgBouncer will be created.                                                                                                                                      | `string` | n/a                      |   yes    |
| users                   | The list of users to be created in PgBouncer's userlist.txt. Passwords can be provided as plain-text or md5 hashes.                                                                         | `list`   | n/a                      |   yes    |
| zone                    | The zone where PgBouncer will be created.                                                                                                                                                   | `string` | n/a                      |   yes    |
| auth_query              | Query to load user’s password from database.                                                                                                                                                | `string` | `null`                   |    no    |
| auth_user               | Any user not specified in `users` will be queried through the `auth_query` query from `pg_shadow` in the database, using `auth_user`. The user for `auth_user` must be included in `users`. | `string` | `null`                   |    no    |
| boot_image              | The boot image used by PgBouncer instances. Defaults to the latest LTS Container Optimized OS version. Must be an image compatible with cloud-init (https://cloud-init.io).                 | `string` | `"cos-cloud/cos-89-lts"` |    no    |
| default_pool_size       | Maximum number of server connections to allow per user/database pair.                                                                                                                       | `number` | `20`                     |    no    |
| disable_public_ip       | Flag to disable the PgBouncer instance from being assigned an external, public IP                                                                                                           | `bool`   | `false`                  |    no    |
| disable_service_account | Flag to disable attaching a service account to the PgBouncer instance.                                                                                                                      | `bool`   | `false`                  |    no    |
| instance_count          | The number of instances of PgBouncer to create. Useful for HA setups.                                                                                                                       | `number` | `1`                      |    no    |
| machine_type            | The machine type of PgBouncer instances.                                                                                                                                                    | `string` | `"f1-micro"`             |    no    |
| max_client_connections  | Maximum number of client connections allowed.                                                                                                                                               | `number` | `100`                    |    no    |
| max_db_connections      | The maximum number of server connections per database (regardless of user). 0 is unlimited.                                                                                                 | `number` | `0`                      |    no    |
| module_depends_on       | List of modules or resources this module depends on.                                                                                                                                        | `list`   | `[]`                     |    no    |
| pgbouncer_custom_config | Custom PgBouncer configuration values to be appended to `pgbouncer.ini`.                                                                                                                    | `string` | `""`                     |    no    |
| pgbouncer_image_tag     | The tag to use for the base PgBouncer `edoburu/pgbouncer` Docker image used by this module.                                                                                                 | `string` | `"latest"`               |    no    |
| pool_mode               | Specifies when a server connection can be reused by other clients. Possible values are `session`, `transaction` or `statement`.                                                             | `string` | `"transaction"`          |    no    |
| public_ip_address       | The public IP address to assign to the PgBouncer instance. If not given, one will be generated. Note: setting this value will limit the instance count to 1.                                | `string` | `null`                   |    no    |
| service_account_email   | The service account e-mail address. If not given, the default Google Compute Engine service account is used.                                                                                | `any`    | `null`                   |    no    |
| service_account_scopes  | A list of service scopes to apply to the PgBouncer instance. Default is the full `cloud-platform` access scope.                                                                             | `any`    | `null`                   |    no    |
| subnetwork              | The name or self-link of the subnet where PgBouncer will be created. Either network or subnetwork must be provided.                                                                         | `string` | `null`                   |    no    |
| tags                    | A list of tags to assign to PgBouncer instances.                                                                                                                                            | `list`   | `[]`                     |    no    |

## Outputs

| Name               | Description                                                        |
| ------------------ | ------------------------------------------------------------------ |
| instance_name      | The name for the PgBouncer instance.                               |
| port               | The port number PgBouncer listens on.                              |
| private_ip_address | The first private IPv4 address assigned to the PgBouncer instance. |
| public_ip_address  | The first public IPv4 address assigned for the PgBouncer instance. |

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.5

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- `roles/compute.instanceAdmin`
- `roles/iam.serviceAccountUser`

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- `compute.googleapis.com`

[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
