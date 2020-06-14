# terraform-cloud-sql-pgbouncer

[![GitHub](https://badgen.net/github/release/christippett/terraform-google-cloud-sql-pgbouncer)](https://github.com/christippett/terraform-google-cloud-sql-pgbouncer) [![Terraform](https://badgen.net/badge/icon/terraform?icon=terraform&label&color=purple)](https://registry.terraform.io/modules/christippett/cloud-sql-pgbouncer/) [![Terraform](https://badgen.net/github/license/micromatch/micromatch)](./LICENSE)

Terraform module for deploying PgBouncer in front of a Cloud SQL PostgreSQL instance.

## Usage

Basic usage of this module is as follows:

```hcl
module "pgbouncer" {
  source  = "christippett/cloud-sql-pgbouncer/google"
  version = "~>1.0"

  project    = var.project
  name       = "pgbouncer"
  zone       = "us-central1-a"
  subnetwork = "subnet-1"

  port          = 25128
  database_host = var.database_host

  users = [
    { name = "user1", password = "password" },
    { name = "user2", password = "password" }
  ]
}
```

Functional examples are included in the
[examples](./examples/) directory.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| database\_host | The host address of the Cloud SQL instance to connect to. | `string` | n/a | yes |
| name | The name of the PgBouncer instance. | `string` | n/a | yes |
| port | The port used by PgBouncer to listen on. | `number` | n/a | yes |
| project | The ID of the project where PgBouncer will be created. | `string` | n/a | yes |
| users | The list of users to be created in PgBouncer's userlist.txt. Passwords can be provided as plain-text or md5 hashes. | `list` | n/a | yes |
| zone | The zone where PgBouncer will be created. | `string` | n/a | yes |
| auth\_query | Query to load user’s password from database. | `string` | `null` | no |
| auth\_user | Any user not specified in `users` will be queried through the `auth_query` query from `pg_shadow` in the database, using `auth_user`. The user for `auth_user` must be included in `users`. | `string` | `null` | no |
| boot\_image | The boot image used by PgBouncer instances. Defaults to the latest LTS Container Optimized OS version. Must be an image compatible with cloud-init (https://cloud-init.io). | `string` | `"cos-cloud/cos-81-lts"` | no |
| default\_pool\_size | Maximum number of server connections to allow per user/database pair. | `number` | `20` | no |
| disable\_public\_ip | Flag to disable the PgBouncer instance from being assigned an external, public IP | `bool` | `false` | no |
| disable\_service\_account | Flag to disable attaching a service account to the PgBouncer instance. | `bool` | `false` | no |
| instance\_count | The number of instances of PgBouncer to create. Useful for HA setups. | `number` | `1` | no |
| machine\_type | The machine type of PgBouncer instances. | `string` | `"f1-micro"` | no |
| max\_client\_connections | Maximum number of client connections allowed. | `number` | `100` | no |
| max\_db\_connections | The maximum number of server connections per database (regardless of user). 0 is unlimited. | `number` | `0` | no |
| module\_depends\_on | List of modules or resources this module depends on. | `list` | `[]` | no |
| pgbouncer\_custom\_config | Custom PgBouncer configuration values to be appended to `pgbouncer.ini`. | `string` | `""` | no |
| pgbouncer\_image\_tag | The tag to use for the base PgBouncer `edoburu/pgbouncer` Docker image used by this module. | `string` | `"latest"` | no |
| pool\_mode | Specifies when a server connection can be reused by other clients. Possible values are `session`, `transaction` or `statement`. | `string` | `"transaction"` | no |
| public\_ip\_address | The public IP address to assign to the PgBouncer instance. If not given, one will be generated. Note: setting this value will limit the instance count to 1. | `string` | `null` | no |
| service\_account\_email | The service account e-mail address. If not given, the default Google Compute Engine service account is used. | `any` | `null` | no |
| service\_account\_scopes | A list of service scopes to apply to the PgBouncer instance. | `list` | <pre>[<br>  "https://www.googleapis.com/auth/cloud-platform"<br>]</pre> | no |
| subnetwork | The name or self-link of the subnet where PgBouncer will be created. Either network or subnetwork must be provided. | `string` | `null` | no |
| tags | A list of tags to assign to PgBouncer instances. | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | The name for the PgBouncer instance. |
| port | The port number PgBouncer listens on. |
| private\_ip\_address | The first private IPv4 address assigned to the PgBouncer instance. |
| public\_ip\_address | The first public IPv4 address assigned for the PgBouncer instance. |

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
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
