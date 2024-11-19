generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOF
    terraform {
      backend "local" {
          path = "./terraform.tfstate"
      }
    }
  EOF
}

generate "terraform" {
  path = "terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOF
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
