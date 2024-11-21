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

locals {
  vars              = read_terragrunt_config("variables.hcl")
  repositories      = local.vars.locals.repositories
  teams             = local.vars.locals.teams
  team_repo_mapping = local.vars.locals.team_repo_mapping

  teams_removed = [
    "team-1",
  ]
  teams_removed_sanitized = {
    for name in local.teams_removed : name => replace(name, "-", "_")
  }
  team_repo_mapping_removed = {
    "team-1" = ["foo"],
  }
  team_repo_removed_pairs = flatten([
    for team in local.teams_removed : [
      for repo in local.team_repo_mapping_removed[team] : {
        team_hyphen     = team
        team_underscore = replace(team, "-", "_")
        repo            = repo
      }
    ]
  ])
}

generate "removed" {
  path      = "removed-generated.tf"
  if_exists = "overwrite"
  contents = templatefile("templates/removed.tmpl", {
    team_names_map  = local.teams_removed_sanitized
    team_repo_pairs = local.team_repo_removed_pairs
  })
}

terraform {
  extra_arguments "common_variables" {
    commands = get_terraform_commands_that_need_vars()
    required_var_files = [
      "${path_relative_from_include()}/pem.tfvars",
      "${path_relative_from_include()}/users.tfvars",
    ]
  }
}

inputs = {
  repositories      = local.repositories
  teams             = local.teams
  team_repo_mapping = local.team_repo_mapping
}
