variable "project_id" {
  type = string
}

# Add support for in future
# variable "service_account" {
#   type = string
#   description = "Service account to use for Cloud Run service. If not provided, one will be created."
#   default = ""
# }

variable "ar_repository_id" {
  type = string
  description = "Name for Artifact Registry repository."
}

variable "region" {
  type = string
  description = "Default region for module resources."
  default = "us-central1"  
}