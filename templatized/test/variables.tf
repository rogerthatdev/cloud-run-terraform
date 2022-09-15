variable "project_id" {
  type = string
}

variable "run_service_name" {
  type =  string
  description = "Name for the Run service."
}

variable "container_image_url" {
  type = string
  description = "URL for Run service container build."

   default = ""
}
