# Example: Cloud SQL over private IP

This example illustrates how to use the `terraform-cloud-sql-pgbouncer` module.

Once created, you can connect to your Cloud SQL PostgreSQL database using the `database_url` output variable.

```bash
$ psql $(terraform output -json | jq -r '.database_url.value')

psql (10.12 (Ubuntu 10.12-0ubuntu0.18.04.1), server 12.1)
WARNING: psql major version 10, server major version 12.
         Some psql features might not work.
Type "help" for help.

# SELECT * FROM information_schema.tables;
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| db\_name | The name of the default database to create. | `string` | `"defaultdb"` | no |
| db\_password | The password of the default database user account. | `string` | n/a | yes |
| db\_user | The name of the default database user account. | `string` | n/a | yes |
| network\_name | The name of the network where PgBouncer will be created. | `string` | n/a | yes |
| project | The ID of the project in which to provision resources. | `string` | n/a | yes |
| subnetwork\_name | The name of the subnet where PgBouncer will be created. | `string` | n/a | yes |
| zone | The zone where PgBouncer will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| database\_url | The database URL for connecting to PgBouncer. |
| instance\_name | The name for the PgBouncer instance. |
| port | The port number PgBouncer listens on. |
| private\_ip\_address | The first private IPv4 address assigned to the PgBouncer instance. |
| public\_ip\_address | The first public IPv4 address assigned for the PgBouncer instance. |

To provision this example, run the following from within this directory:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
