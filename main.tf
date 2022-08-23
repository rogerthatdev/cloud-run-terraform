resource "google_project_service" "cloud_run" {
   service = "run.googleapis.com"
}

resource "google_service_account" "runner" {
  account_id   = "cloud-runner"
  display_name = "Cloud Run runner"
}

resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/hello-test"
        ports {
          container_port = 3000
        }
      }
      service_account_name = google_service_account.runner.email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
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
  service     = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location
  project = var.project_id
  policy_data = data.google_iam_policy.noauth.policy_data
}