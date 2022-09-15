variable "project_id" {
  type = string
}

variable "run_service_name" {
  type =  string
  description = "Name for the Run service."
}

variable "primary_revision_image_url" {
  type = string
  description = "URL for Run service container build."
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "revision_b_name" {
  type = string
  description = "Name of revision B. Must be existing revision, otherwise module will default to last created revision."
  default = ""
}

# variable "revision_c_name" {
#   type = string
#   description = "Name of revision C. Must be existing revision, otherwise module will default to primary revision."
#   default = ""
# }