
locals {
  services = [
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}


resource "google_project_service" "default" {
  project                    = var.project_id
  for_each                   = toset(local.services)
  service                    = each.value
  disable_dependent_services = true
}