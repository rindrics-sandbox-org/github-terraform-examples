variable "repositories" {
  type = list(string)
  default = [
    "foo",
    "bar",
    "baz",
  ]
}

variable "teams" {
  type = list(string)
  default = [
    "team-2",
    "team-3",
    "team-4",
    "team-5",
  ]
}

variable "team_repo_mapping" {
  type = map(list(string))
  default = {
    "team-1" = ["foo"]
    "team-2" = ["foo", "baz"]
    "team-3" = ["foo", "bar", "baz"]
    "team-4" = ["baz"]
    "team-5" = ["foo", "bar", "baz"]
  }
}
