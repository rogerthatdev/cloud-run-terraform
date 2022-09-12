data "google_cloud_run_service" "run_service" {
  project  = var.project_id
  name     = google_cloud_run_service.my_app.name
  location = "us-central1"
}

output "run_endpoint_url" {
    value = data.google_cloud_run_service.run_service.status[0].url
}

output "run_last_created_revision" {
    value = data.google_cloud_run_service.run_service.status[0].latest_created_revision_name
}

output "run_entire_data_object" {
    value = data.google_cloud_run_service.run_service
}