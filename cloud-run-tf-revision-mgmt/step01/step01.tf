# Step 1 is to create the artifact registry 

resource "google_artifact_registry_repository" "my_other_repo" {
  project       = var.project_id
  location      = "us-central1"
  repository_id = "website-plus"
  description   = "example docker repository"
  format        = "DOCKER"
}

