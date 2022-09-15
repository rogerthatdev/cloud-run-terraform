locals {
  boiler_plate_image    = "us-docker.pkg.dev/cloudrun/container/hello"
  is_first_time         = data.google_cloud_run_service.run-service.id == null ? true : false
  # TODO: Revision name
  revision_name         = local.is_first_time ? "${var.run_service_name}-boilerplate" : "${var.run_service_name}-boilerplate"
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service" "my_app" {
  project  = var.project_id
  name     = var.run_service_name
  location = var.region
  template {
    spec {
      containers {
        image = local.is_first_time ? local.boiler_plate_image : var.container_image_url
      }
      service_account_name = google_service_account.runner.email
    }
    # name the revision for the canaray build
    metadata {
      name = local.revision_name
    }
  }
  # change this block to point to the initial build
  traffic {
    percent       = 100
    # will always be new revision
    revision_name =  local.revision_name
  }
  # this needs to be provided
  traffic {
    percent       = 0
    revision_name = local.is_first_time ? local.revision_name : local.revision_name
  }

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

data "google_cloud_run_service" "run-service" {
  project = var.project_id
  name = var.run_service_name
  location = var.region
}

output "service_run" {
  value = data.google_cloud_run_service.run-service.id == null ? "FIRST TIME!" : "NOT FIRST TIME"
}

# resource "google_cloud_run_service_iam_policy" "noauth" {
#   location = google_cloud_run_service.my_app.location
#   project  = google_cloud_run_service.my_app.project
#   service  = google_cloud_run_service.my_app.name

#   policy_data = data.google_iam_policy.noauth.policy_data
  
# }