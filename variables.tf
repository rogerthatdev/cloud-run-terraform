variable "project_id" {
    type = string
}

variable "image_sha" {
    type = string
    description = "SHA for image to use in Cloud Run service."
}