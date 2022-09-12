# Services
locals {
  services = [
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}

resource "google_project_service" "default" {
  project = var.project_id
  for_each = toset(local.services)
  service = each.value
  disable_dependent_services = true
}

# Step 1 is to create the artifact registry that will be used by all projects in the ops project

resource "google_artifact_registry_repository" "my_repo" {
  project       = var.project_id
  location      = "us-central1"
  repository_id = "website"
  description   = "example docker repository"
  format        = "DOCKER"

  depends_on = [
    resource.google_project_service.default
  ]
}

