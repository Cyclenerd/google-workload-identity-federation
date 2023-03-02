# GOOGLE PROJECT

variable "project_id" {
  type        = string
  description = "The ID of the project"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Invalid project ID!"
  }
}

# IDENTITY POOL

variable "pool_name" {
  type        = string
  description = "The resource name of the Workload Identity Pool"
}

# SERVICE ACCOUNT

variable "account_id" {
  type        = string
  description = "The account id of the service account"
  validation {
    condition     = length(regex("([a-z0-9-]{6,30})", var.account_id)) == 1
    error_message = "The 'account_id' value should be 6-30 characters, and may contain the characters [a-z0-9-]."
  }
}

# REPOSITORY

variable "repository" {
  type        = string
  description = "Repository patch (i.e. 'Cyclenerd/google-workload-identity-federation')"
}

# SUBJECT
# GitHub: repo:username/reponame:ref:refs/heads/main
# GitLab: project_path:username/reponame:ref_type:branch:ref:main

variable "subject" {
  type        = string
  description = "Subject (i.e. 'repo:username/reponame:ref:refs/heads/main')"
  default     = null
}