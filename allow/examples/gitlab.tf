# Create Workload Identity Pool Provider for GitLab
module "gitlab-wif" {
  source     = "../../gitlab"
  project_id = var.project_id
}

# Get existing service account for GitLab CI
data "google_service_account" "gitlab" {
  project    = var.project_id
  account_id = var.gitlab_account_id
}

# Allow service account to login via WIF
module "gitlab-allow" {
  source     = "../../allow"
  project_id = var.project_id
  pool_name  = module.gitlab-wif.pool_name
  account_id = data.google_service_account.gitlab.account_id
  repository = "Cyclenerd/google-workload-identity-federation-for-gitlab"
}

# Get the Workload Identity Pool Provider resource name for GitLab CI configuration
output "gitlab-workload-identity-provider" {
  description = "The Workload Identity Provider resource name"
  value       = module.gitlab-wif.provider_name
}