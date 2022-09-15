locals {
  # is_first_time used to enable deploy Run service without a provided image in cases where AR is created along side Run service and before builds are pushed.
  # is_first_time         = data.google_cloud_run_service.run-service.id == null ? true : false
  # boiler_plate_image    = "us-docker.pkg.dev/cloudrun/container/hello"
  primary_revision_name = "${var.run_service_name}-${random_id.revision_suffix.hex}"
  revision_names        =  {
    revision_b          = var.revision_b_name == "" ? local.primary_revision_name : var.revision_b_name
  }
}

resource "random_id" "revision_suffix" {
  keepers = {
    # Generate a new suffix everytime primary_revision_image_url is changed.
    primary_revision_image_url = var.primary_revision_image_url
  }
  byte_length = 3
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
    percent       = 75
    # will always be new revision
    revision_name =  local.primary_revision_name
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

data "google_cloud_run_service" "run-service" {
  project = var.project_id
  name = var.run_service_name
  location = var.region
  
  depends_on = [
    time_sleep.wait_60_seconds
  ]
}

output "service_run" {
  value = data.google_cloud_run_service.run-service.id == null ? "FIRST TIME!" : "NOT FIRST TIME"
}


resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.my_app.location
  project  = google_cloud_run_service.my_app.project
  service  = google_cloud_run_service.my_app.name

  policy_data = data.google_iam_policy.noauth.policy_data
  
}

# us-central1-docker.pkg.dev/cloud-run-fafo-f241/website
# /website image_name
# tag
