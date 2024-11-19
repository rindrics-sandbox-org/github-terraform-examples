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

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOF
    provider "github" {
    owner = "rindrics-sandbox-org"
    app_auth {
        pem_file = var.pem_content
    }
  }
  EOF
}
