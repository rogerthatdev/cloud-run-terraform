module "cloud_run_service" {
  source          = "../modules/cloud-run-service"
  project_id      = var.project_id
  ar_repository_id = var.ar_repository_id
}
