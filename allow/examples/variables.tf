variable "project_id" {
  type        = string
  description = "The ID of the project"
}

variable "github_account_id" {
  type        = string
  description = "The account id of the service account for GitHub Action"
}

variable "gitlab_account_id" {
  type        = string
  description = "The account id of the service account for GitLab CI"
}