resource "google_artifact_registry_repository" "my_repo" {
  project       = var.project_id
  location      = "us-central1"
  repository_id = "website"
  description   = "example docker repository"
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