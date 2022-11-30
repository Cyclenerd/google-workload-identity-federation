locals {
  // You need to set your own values for the variables here
  PROJECT_ID               = "your project id"
  PROJECT_NUMBER           = 1234
  REPO                     = "userName/repoName" // eg Cyclenerd/google-workload-identity-federation
  MY_SERVICE_ACCOUNT_EMAIL = "example@appspot.gserviceaccount.com"
}

provider "google" {
  project = local.PROJECT_ID
}

resource "google_project_service" "iamcredentials" {
  project = local.PROJECT_ID
  service = "iamcredentials.googleapis.com"
}

resource "google_iam_workload_identity_pool" "gitlab" {
  workload_identity_pool_id = "gitlab"
  project                   = local.PROJECT_ID
  display_name              = "GitLab CI"
}

resource "google_iam_workload_identity_pool_provider" "cicd" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.gitlab.workload_identity_pool_id
  workload_identity_pool_provider_id = "cicd"
  display_name                       = "GitLab CI OIDC"
  project                            = local.PROJECT_ID
  attribute_mapping = {
    "google.subject"         = "assertion.sub",
    "attribute.repository"   = "assertion.repository"
    "attribute.actor"        = "assertion.actor"
    "attribute.project_path" = "assertion.project_path"
  }
  oidc {
    issuer_uri        = "https://gitlab.com"
    allowed_audiences = ["https://gitlab.com"]
  }
}

### Role bindings for the SA to be able to use WIF

resource "google_project_iam_member" "sa_wif_binding" {
  role    = "roles/iam.workloadIdentityUser"
  project = local.PROJECT_ID
  member  = "serviceAccount:${local.MY_SERVICE_ACCOUNT_EMAIL}"
}

/*
Allow authentications from the Workload Identity Provider originating from your repository to impersonate the Service Account:
*/
resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = "projects/${local.PROJECT_NUMBER}/serviceAccounts/${local.MY_SERVICE_ACCOUNT_EMAIL}"
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/projects/${local.PROJECT_NUMBER}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.gitlab.workload_identity_pool_id}/attribute.project_path/${local.REPO}"
  ]
}