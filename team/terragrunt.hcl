generate "backend" {
  path      = "backend-generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      backend "local" {
        path = "./terraform.tfstate"
      }
    }
  EOF
}

generate "terraform" {
  path      = "terraform-generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_version = "~> 1.9.5" # be consistent with `.terraform-version`

      required_providers {
        github = {
          source  = "integrations/github"
          version = "~> 6.3"
        }
      }
    }

    provider "github" {
      owner = "rindrics-sandbox-org"
      app_auth {
        pem_file = var.pem_content
      }
    }
  EOF
}

generate "variables" {
  path      = "variables-generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    variable "pem_content" {
      type        = string
      description = "The content of the PEM file"
    }
  EOF
}

generate "pem" {
  path      = "pem-generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    locals {
      pem_content = var.pem_content
    }
  EOF
}

terraform {
  extra_arguments "common_variables" {
    commands = get_terraform_commands_that_need_vars()
    required_var_files = [
      "${path_relative_from_include()}/../pem.tfvars",
      "${path_relative_from_include()}/../users.tfvars",
    ]
  }
}

inputs = {
  name        = path_relative_to_include()
}

generate "imports" {
  path      = "imports-generated.tf"
  if_exists = "overwrite"

  contents = templatefile("templates/import.tmpl", {
    name = path_relative_to_include()
  })
}
