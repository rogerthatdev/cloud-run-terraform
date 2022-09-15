variable "project_id" {
  type = string
}

# Add support for in future
# variable "service_account" {
#   type = string
#   description = "Service account to use for Cloud Run service. If not provided, one will be created."
#   default = ""
# }

variable "region" {
  type        = string
  description = "Default region for module resources."
  default     = "us-central1"
}

variable "run_service_name" {
  type        = string
  description = "Name for the Run service."
}

variable "primary_revision_image_url" {
  type        = string
  description = "URL for Run service container build."
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "revision_b_name" {
  type        = string
  description = "Name of revision B. Must be existing revision, otherwise module will default to revision a."
  default     = ""
}