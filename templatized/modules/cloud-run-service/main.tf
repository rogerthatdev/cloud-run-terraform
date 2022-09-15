data "google_project" "app" {
  project_id = var.project_id
}

# Service accounts

output "all_outputs" {
    value = [
        ""
    ]
}

resource "random_string" "service_account_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "google_service_account" "runner" {
  project      = var.project_id
  account_id   = "clound-runner-${random_string.service_account_suffix.result}"
  display_name = "Cloud Run service runner"
}

resource "google_project_service_identity" "cloud_run_agent" {
  provider = google-beta
  project  = data.google_project.app.project_id
  service  = "run.googleapis.com"
}

# Artifact Reg

resource "google_artifact_registry_repository" "my_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.ar_repository_id
  description   = "Docker repository for ${var.ar_repository_id}"
  format        = "DOCKER"

  depends_on = [
    resource.google_project_service.default
  ]
}

resource "google_artifact_registry_repository_iam_member" "api_cloudrun_role_ar_reader" {
  provider   = google
  project    = var.project_id
  location   = "us-central1"
  repository = "website"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_project_service_identity.cloud_run_agent.email}"
  depends_on = [
    google_artifact_registry_repository.my_repo
  ]
}