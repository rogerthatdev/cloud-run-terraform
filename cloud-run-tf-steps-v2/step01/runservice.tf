
resource "google_cloud_run_service" "my_app" {
  project  = var.project_id
  name     = "website"
  location = "us-central1"
  template {
    spec {
      containers {
        image = local.place_holder_container_image
      }
      service_account_name = google_service_account.runner.email
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }

}