# Step01: Create Artifact registry, associated IAM policies and Cloud Run service with placeholder for image

# Services
locals {
  services = [
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
  run_container_image = "us-docker.pkg.dev/cloudrun/container/hello"
}

resource "google_project_service" "default" {
  project                    = var.project_id
  for_each                   = toset(local.services)
  service                    = each.value
  disable_dependent_services = true
}

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

resource "google_service_account" "runner" {
  project      = var.project_id
  account_id   = "cloud-runner"
  display_name = "Cloud Run runner"
}


data "google_project" "app" {
  project_id = var.project_id
}

# Grant artifact registry access to Run service agent

resource "google_project_service_identity" "cloud_run_agent" {
  provider = google-beta
  project  = data.google_project.app.project_id
  service  = "run.googleapis.com"
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


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.my_app.location
  project  = google_cloud_run_service.my_app.project
  service  = google_cloud_run_service.my_app.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
