# Create Workload Identity Pool Provider for GitHub
module "github-wif" {
  source     = "../../github"
  project_id = var.project_id
}

# Get existing service account for GitHub Action
data "google_service_account" "github" {
  project    = var.project_id
  account_id = var.github_account_id
}

# Allow service account to login via WIF
module "github-allow" {
  source     = "../../allow"
  project_id = var.project_id
  pool_name  = module.github-wif.pool_name
  account_id = data.google_service_account.github.account_id
  repository = "Cyclenerd/google-workload-identity-federation"
}

# Get the Workload Identity Pool Provider resource name for GitHub Action configuration
output "github-workload-identity-provider" {
  description = "The Workload Identity Provider resource name"
  value       = module.github-wif.provider_name
}