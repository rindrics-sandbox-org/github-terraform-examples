locals {
  repositories = [
    "foo",
    "bar",
    "baz",
  ]

  teams = [
    "team-2",
    "team-3",
    "team-4",
    "team-5",
  ]

  team_repo_mapping = {
    "team-1" = ["foo"]
    "team-2" = ["foo", "baz"]
    "team-3" = ["foo", "bar", "baz"]
    "team-4" = ["baz"]
    "team-5" = ["foo", "bar", "baz"]
  }
}
