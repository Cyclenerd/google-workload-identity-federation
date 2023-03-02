# API
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service

resource "google_project_service" "iam" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudresourcemanager" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iamcredentials" {
  project            = var.project_id
  service            = "iamcredentials.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sts" {
  project            = var.project_id
  service            = "sts.googleapis.com"
  disable_on_destroy = false
}

# IDENTITY POOL
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool

resource "google_iam_workload_identity_pool" "pool" {
  project = var.project_id

  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = var.pool_description
  disabled                  = var.pool_disabled

  depends_on = [google_project_service.iamcredentials]
}

# IDENTITY POOL PROVIDER
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider

resource "google_iam_workload_identity_pool_provider" "provider" {
  project = var.project_id

  workload_identity_pool_id = google_iam_workload_identity_pool.pool.workload_identity_pool_id

  workload_identity_pool_provider_id = var.provider_id
  display_name                       = var.provider_display_name
  description                        = var.provider_description
  disabled                           = var.provider_disabled

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.sub"        = "attribute.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.project_path"
  }
  oidc {
    allowed_audiences = [var.allowed_audiences]
    issuer_uri        = var.issuer_uri
  }

  depends_on = [google_iam_workload_identity_pool.pool]
}