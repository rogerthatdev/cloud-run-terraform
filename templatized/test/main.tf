module "cloud_run_service" {
  source          = "../modules/cloud-run-service"
  project_id      = var.project_id
  run_service_name = var.run_service_name
  primary_revision_image_url = var.primary_revision_image_url
  revision_b_name = var.revision_b_name
}

output "service_run" {
  value = module.cloud_run_service.service_run
}

output "all_outputs" {
  value = module.cloud_run_service.all_outputs
}