# Step 3 is to create a run service that references an image in the created artifact registry

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
}

resource "google_cloud_run_service" "my_app" {
  project  = var.project_id
  name     = "website"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/${var.project_id}/website/website:latest"
      }
      service_account_name = google_service_account.runner.email
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }

}
