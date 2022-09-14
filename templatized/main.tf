# Services
variable "service_container_image" {
    type = string
    default = ""
}

variable "revision_a_tag" {
    type = string
    # default = latest
}


variable "revision_b_tag" {
    type = string
}

variable "revision_a_percent" {
    type = number
    default = 100
}

variable "revision_b_percent" {
    type = number
    default = 0
}

locals {
  boiler_plate_image    = "us-docker.pkg.dev/cloudrun/container/hello"
  run_service_name      = "tf-website"
  # make this be boilerplate if no ar
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




resource "google_cloud_run_service" "my_app" {
  project  = var.project_id
  name     = local.run_service_name
  location = "us-central1"
  template {
    spec {
      containers {
        # update to canary build
        image = var.service_container_image == "" ? local.boiler_plate_image : "${var.service_container_image}:${var.revision_a_tag}"
      }
      service_account_name = google_service_account.runner.email
    }
    # name the revision for the canaray build
    metadata {
      name = var.service_container_image == "" ? "${local.run_service_name}-boilerplate" : "${local.run_service_name}-${var.revision_a_tag}"
    }
  }
  # change this block to point to the initial build
  traffic {
    percent       = var.revision_a_percent
    revision_name = var.service_container_image == "" ? "${local.run_service_name}-boilerplate" : "${local.run_service_name}-${var.revision_a_tag}"
  }
  # Right off the bat indicate the revision name used above
  traffic {
    percent       = var.revision_b_percent
    revision_name = var.service_container_image == "" ? "${local.run_service_name}-boilerplate" : "${local.run_service_name}-${var.revision_b_tag}"
  }
}