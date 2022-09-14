# Step 5 will update the run service to roll out canary to 20%

# STEP 3 run service:

# locals {
#   app_container_image = "us-central1-docker.pkg.dev/${var.project_id}/website/website:latest"
#   run_service_name = "website"
# }
# resource "google_cloud_run_service" "my_app" {
#   project  = var.project_id
#   name     = local.run_service_name
#   location = "us-central1"
#   template {
#     spec {
#       containers {
#         image = local.app_container_image
#       }
#       service_account_name = google_service_account.runner.email
#     }
#   metadata {
#     name = "${local.run_service_name}-initial-build"
#   }
#   }
#   traffic {
#     percent         = 100
#     latest_revision = true
#   }
# }

locals {
  app_container_image    = "us-central1-docker.pkg.dev/${var.project_id}/website/website:latest"
  canary_container_image = "us-central1-docker.pkg.dev/${var.project_id}/website/website:canary"
  run_service_name       = "website"
}

resource "google_cloud_run_service" "my_app" {
  project  = var.project_id
  name     = local.run_service_name
  location = "us-central1"
  template {
    spec {
      containers {
        # update to canary build
        image = local.canary_container_image
      }
      service_account_name = google_service_account.runner.email
    }
    # name the revision for the canaray build
    metadata {
      name = "${local.run_service_name}-canary-build"
    }
  }
  # change this block to point to the initial build
  traffic {
    percent       = 80
    revision_name = "${local.run_service_name}-initial-build"
  }
  # Right off the bat indicate the revision name used above
  traffic {
    percent       = 20
    revision_name = "${local.run_service_name}-canary-build"
  }
}