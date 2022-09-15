data "google_project" "app" {
  project_id = var.project_id
}

# Service accounts

output "all_outputs" {
    value = {
      # needed for AR reader permissions
      "cloud_run_agent" = google_project_service_identity.cloud_run_agent.email
    }
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
