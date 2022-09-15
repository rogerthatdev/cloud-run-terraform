locals {
  primary_revision_name = "${var.run_service_name}-${random_id.revision_suffix.hex}"
  # TODO: add support for more revisions
  revision_names = {
    revision_b = var.revision_b_name == "" ? local.primary_revision_name : var.revision_b_name
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

resource "random_id" "revision_suffix" {
  keepers = {
    # Generate a new suffix everytime primary_revision_image_url is changed.
    primary_revision_image_url = var.primary_revision_image_url
  }
  byte_length = 3
}

resource "google_cloud_run_service" "my_app" {
  project  = var.project_id
  name     = var.run_service_name
  location = var.region
  template {
    spec {
      containers {
        image = var.primary_revision_image_url
      }
      service_account_name = google_service_account.runner.email
    }
    metadata {
      name = local.primary_revision_name
    }
  }
  # This is the primary revision
  traffic {
    # TODO: add support for adjusting percentages
    percent = 75
    # will always be new revision
    revision_name = local.primary_revision_name
  }
  # This is revision B. Defaults to the same as revision A if not provided.
  traffic {
    percent       = 25
    revision_name = local.revision_names.revision_b
  }

  depends_on = [
    time_sleep.wait_60_seconds
  ]
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.my_app.location
  project  = google_cloud_run_service.my_app.project
  service  = google_cloud_run_service.my_app.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

# Can be used to check if this is the first time creating Run Service (id will be null if resource doesn't exist.)
data "google_cloud_run_service" "run-service" {
  project  = var.project_id
  name     = var.run_service_name
  location = var.region

  depends_on = [
    time_sleep.wait_60_seconds
  ]
}