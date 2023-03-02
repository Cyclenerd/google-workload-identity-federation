# Terraform Examples for Identity Federation

The following example shows you how to configure Workload Identity Federation via Terraform IaC.

## Modules

Three Terraform modules are prepared and can be used:

| Module                  | Source                                                                              |
|-------------------------|-------------------------------------------------------------------------------------|
| [GitHub](../../github/) | `git::https://github.com/Cyclenerd/google-workload-identity-federation.git//github` |
| [GitLab](../../gitlab/) | `git::https://github.com/Cyclenerd/google-workload-identity-federation.git//gitlab` |
| [Allow](../)            | `git::https://github.com/Cyclenerd/google-workload-identity-federation.git//allow`  |

### GitHub

Create Workload Identity Pool and Provider:

```hcl
# Create Workload Identity Pool Provider for GitHub
module "github-wif" {
  source     = "git::https://github.com/Cyclenerd/google-workload-identity-federation.git//github"
  project_id = var.project_id
}

# Get the Workload Identity Pool Provider resource name for GitHub Action configuration
output "github-workload-identity-provider" {
  description = "The Workload Identity Provider resource name"
  value       = module.github-wif.provider_name
}
```

[💁 More Help and Documentation](../../github/)

### GitLab

Create Workload Identity Pool and Provider:

```hcl
# Create Workload Identity Pool Provider for GitLab
module "gitlab-wif" {
  source     = "git::https://github.com/Cyclenerd/google-workload-identity-federation.git//gitlab"
  project_id = var.project_id
}

# Get the Workload Identity Pool Provider resource name for GitLab CI configuration
output "gitlab-workload-identity-provider" {
  description = "The Workload Identity Provider resource name"
  value       = module.gitlab-wif.provider_name
}
```

[💁 More Help and Documentation](../../gitlab/)

### Allow

Allow service account to login via Workload Identity Provider:

```hcl
# GitHub
module "github-allow" {
  source     = "git::https://github.com/Cyclenerd/google-workload-identity-federation.git//allow"
  project_id = var.project_id
  pool_name  = module.github-wif.pool_name
  account_id = data.google_service_account.github.account_id
  repository = "Cyclenerd/google-workload-identity-federation"
}

# GitLab
module "gitlab-allow" {
  source     = "git::https://github.com/Cyclenerd/google-workload-identity-federation.git//allow"
  project_id = var.project_id
  pool_name  = module.gitlab-wif.pool_name
  account_id = data.google_service_account.gitlab.account_id
  repository = "Cyclenerd/google-workload-identity-federation-for-gitlab"
}
```

[💁 More Help and Documentation](../)

<!-- BEGIN_TF_DOCS -->
## Examples

### GitHub
```hcl
# GITHUB

# Create Workload Identity Pool Provider
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
```

## GitLab
```hcl
# GITLAB

# Create Workload Identity Pool Provider
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
```
<!-- END_TF_DOCS --> 
