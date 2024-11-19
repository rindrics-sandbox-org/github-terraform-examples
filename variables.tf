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
    "team-1",
    "team-2",
    "team-3",
    "team-4",
    "team-5",
  ]
}
