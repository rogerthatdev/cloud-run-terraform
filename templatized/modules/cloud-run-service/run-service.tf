data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}





# resource "google_cloud_run_service" "my_app" {
#   project  = var.project_id
#   name     = local.run_service_name
#   location = "us-central1"
#   template {
#     spec {
#       containers {
#         # update to canary build
#         image = var.service_container_image == "" ? local.boiler_plate_image : "${var.service_container_image}:${var.revision_a_tag}"
#       }
#       service_account_name = google_service_account.runner.email
#     }
#     # name the revision for the canaray build
#     metadata {
#       name = var.service_container_image == "" ? "${local.run_service_name}-boilerplate" : "${local.run_service_name}-${var.revision_a_tag}"
#     }
#   }
#   # change this block to point to the initial build
#   traffic {
#     percent       = var.revision_a_percent
#     revision_name = var.service_container_image == "" ? "${local.run_service_name}-boilerplate" : "${local.run_service_name}-${var.revision_a_tag}"
#   }
#   # Right off the bat indicate the revision name used above
#   traffic {
#     percent       = var.revision_b_percent
#     revision_name = var.service_container_image == "" ? "${local.run_service_name}-boilerplate" : "${local.run_service_name}-${var.revision_b_tag}"
#   }
# }


# resource "google_cloud_run_service_iam_policy" "noauth" {
#   location = google_cloud_run_service.my_app.location
#   project  = google_cloud_run_service.my_app.project
#   service  = google_cloud_run_service.my_app.name

#   policy_data = data.google_iam_policy.noauth.policy_data
  
# }