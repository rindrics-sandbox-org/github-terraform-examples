resource "github_team" "this" {
  name    = var.name
  privacy = "closed"
}

variable "name" {
  type        = string
  description = "The name of the team"
}
