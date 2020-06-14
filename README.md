# terraform-cloud-sql-pgbouncer

## Usage

Basic usage of this module is as follows:

```hcl
module "pgbouncer" {
  version = "~> 0.1"

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

- TBC ⌛

## Outputs

- TBC ⌛

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.5

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- TBC ⌛

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- TBC ⌛

[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
