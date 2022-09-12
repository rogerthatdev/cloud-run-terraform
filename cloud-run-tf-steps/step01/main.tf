variable "project_id" {
    type = string
    default = "emblem-ops-359b"  
}

# Step 1 is to create the artifact registry that will be used by all projects in the ops project

resource "google_artifact_registry_repository" "my_repo" {
  project       = var.project_id
  location      = "us-central1"
  repository_id = "website"
  description   = "example docker repository"
  format        = "DOCKER"
}

