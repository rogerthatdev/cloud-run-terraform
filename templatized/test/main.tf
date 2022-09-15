module "cloud_run_service" {
  source          = "../modules/cloud-run-service"
  project_id      = var.project_id
  run_service_name = var.run_service_name
  container_image_url = var.container_image_url
}

output "service_run" {
  value = module.cloud_run_service.service_run
}

output "all_outputs" {
  value = module.cloud_run_service.all_outputs
}