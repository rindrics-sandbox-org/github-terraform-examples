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
