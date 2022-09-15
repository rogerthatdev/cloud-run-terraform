output "all_outputs" {
  value = {
    # needed for AR reader permissions
    "cloud_run_agent" = google_project_service_identity.cloud_run_agent.email
    "run_service_traffic" = google_cloud_run_service.my_app.traffic
  }
}