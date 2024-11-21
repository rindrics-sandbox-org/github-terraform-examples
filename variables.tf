variable "repositories" {
  type = list(string)
}

variable "teams" {
  type = list(string)
}

variable "team_repo_mapping" {
  type = map(list(string))
}
