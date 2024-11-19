resource "github_repository" "all_in_one" {
  for_each = toset(var.repositories)

  name       = each.value
  visibility = "public"
}

resource "github_team" "all_in_one" {
  for_each = toset(var.teams)

  name    = each.value
  privacy = "closed"
}

resource "github_team_membership" "all_in_one" {
  for_each = github_team.all_in_one

  team_id  = each.value.name
  username = one([for m in github_membership.org_owner : m.username if m.username == "Rindrics"])
  role     = "maintainer"
}

resource "github_team_repository" "all_in_one" {
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

  team_id    = github_team.all_in_one[each.value.team].id
  repository = github_repository.all_in_one[each.value.repo].name
  permission = "maintain"
}
