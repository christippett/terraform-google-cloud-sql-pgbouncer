# PgBouncer cloud-init configuration

This sub-module generates a [cloud-init](https://cloud-init.io/) configuration file required to set up and server PgBouncer on any cloud-init supported platform.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| database\_host | The host address of the Cloud SQL instance to connect to. | `string` | n/a | yes |
| database\_port | The port to connect to the database with. | `number` | `5432` | no |
| listen\_port | The port used by PgBouncer to listen on. | `number` | n/a | yes |
| users | The list of users to be created in PgBouncer's userlist.txt. Passwords can be provided as plain-text or md5 hashes. | `list` | n/a | yes |
| auth\_user | Any user not specified in `users` will be queried through the `auth_query` query from `pg_shadow` in the database, using `auth_user`. The user for `auth_user` must be included in `users`. | `string` | `null` | no |
| auth\_query | Query to load user’s password from database. | `string` | `null` | no |
| pool\_mode | Specifies when a server connection can be reused by other clients. Possible values are `session`, `transaction` or `statement`. | `string` | `"transaction"` | no |
| default\_pool\_size | Maximum number of server connections to allow per user/database pair. | `number` | `20` | no |
| max\_client\_connections | Maximum number of client connections allowed. | `number` | `100` | no |
| max\_db\_connections | The maximum number of server connections per database (regardless of user). 0 is unlimited. | `number` | `0` | no |
| max\_client\_conn | The maximum number of server connections per database (regardless of user). 0 is unlimited. | `number` | `0` | no |
| custom\_config | Custom PgBouncer configuration values to be appended to `pgbouncer.ini`. | `string` | `""` | no |
| pgbouncer\_image\_tag | The tag to use for the base PgBouncer `edoburu/pgbouncer` Docker image used by this module. | `string` | `"latest"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloud\_config | Cloud-init config to set up and serve PgBouncer. |
