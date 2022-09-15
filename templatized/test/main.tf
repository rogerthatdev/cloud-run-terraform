module "cloud_run_service" {
  source          = "../modules/cloud-run-service"
  project_id      = var.project_id
  ar_repository_id = var.ar_repository_id
  run_service_name = var.run_service_name
  container_image_url = var.container_image_url
}

output "service_run" {
  value = module.cloud_run_service.service_run
}

output "ar_registry_url" {
  value = module.cloud_run_service.ar_registry_url
}