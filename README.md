# Drone x Digital Ocean x Terraform

Setup [Drone](https://github.com/drone/drone) on [Digital Ocean](https://www.digitalocean.com/) the [Terraform](https://www.terraform.io/) way.

## Usage

1. Clone this repository.
2. `cd drone-digital-ocean-terraform`.
3. Use the `terraform.tfvars.sample` given. `cp terraform.tfvars.sample terraform.tfvars`.
4. Set the value for all the variables in `terraform.tfvars`. Refer `terraform.tfvars.sample` for the details of each variables.
5. Run `terraform plan` to double check the configuration.
6. Run `terraform apply` to build this infrastructure.
