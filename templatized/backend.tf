terraform {
  backend "gcs" {
    bucket = "rtd-tf-states"
    prefix = "rtd-b-seed-7cf5/cloud-fafo/cloud-run-terraform-templatized"
  }
}