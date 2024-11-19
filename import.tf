# このファイルは、既存のリソースを Terraform 管理下に置くための特別な構成ファイルです。  
# 既存のリポジトリを Terraform 管理下に置くためには import ブロックを使用する必要があります。
# `terraform-operations` と `terraform-state-files`はそれぞれ作成したリポジトリ名に変更してください。( リソース名も同様 )
# `<Organization Name>` と `< GitHub Username >` 部分は適切な値に置き換えてください。
import {
  to = github_repository.terraform_operations
  id = "github-terraform-examples"
}
import {
  to = github_repository.terraform_state_files
  id = "terraform-state-files"
}
import {
  to = github_membership.org_owner["Rindrics"]
  id = "rindrics-sandbox-org:Rindrics"
}

import {
  for_each = toset(var.repositories)
  to       = github_repository.all_in_one[each.key]
  id       = each.value
}

import {
  for_each = toset(var.teams)
  to       = github_team.all_in_one[each.key]
  id       = each.value
}

import {
  for_each = toset(var.teams)
  to       = github_team_membership.all_in_one[each.key]
  id       = "${each.value}:Rindrics"
}

import {
  for_each = {
    for pair in flatten([
      for team, repos in var.team_repo_mapping : [
        for repo in repos : {
          team = team
          repo = repo
        }
      ]
    ]) : "${pair.team}:${pair.repo}" => pair
  }
  to = github_team_repository.all_in_one["${each.value.team}:${each.value.repo}"]
  id = "${each.value.team}:${each.value.repo}"
}
