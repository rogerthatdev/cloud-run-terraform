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
  type = string
  description = "Default region for module resources."
  default = "us-central1"  
}

variable "run_service_name" {
  type =  string
  description = "Name for the Run service."
}

variable "container_image_url" {
  type = string
  description = "URL for Run service container build."
  default     = ""
}

variable "image_name" {
  type = string
  description = "Name of container in AR repo"
  default     = ""
}


variable "image_tag" {
  type = string
  description = "Tag for image to use"
  default     = ""
}
