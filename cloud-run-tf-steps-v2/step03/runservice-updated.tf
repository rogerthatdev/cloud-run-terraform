# Step 3 will update the run service in step 1 to roll out an initial revision with the application image:

# STEP 1 run service:

# resource "google_cloud_run_service" "my_app" {
#   project  = var.project_id
#   name     = "website"
#   location = "us-central1"
#   template {
#     spec {
#       containers {
#         image = local.place_holder_container_image
#       }
#       service_account_name = google_service_account.runner.email
#     }
#   }
#   traffic {
#     percent         = 100
#     latest_revision = true
#   }
# }
locals {
  app_container_image = "us-central1-docker.pkg.dev/${var.project_id}/website/website:latest"
  run_service_name = "website"
}
resource "google_cloud_run_service" "my_app" {
  project  = var.project_id
  name     = local.run_service_name
  location = "us-central1"
  template {
    spec {
      containers {
        image = local.app_container_image
      }
      service_account_name = google_service_account.runner.email
    }
  metadata {
    name = "${local.run_service_name}-initial-build"
  }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}