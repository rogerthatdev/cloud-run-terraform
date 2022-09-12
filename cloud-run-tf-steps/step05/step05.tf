data "google_cloud_run_service" "run_service" {
  project  = var.project_id
  name     = google_cloud_run_service.my_app.name
  location = "us-central1"
}

output "run_endpoint_url" {
    value = data.google_cloud_run_service.run_service.status[0].url
}

output "run_last_created_revision" {
    value = data.google_cloud_run_service.run_service.status[0].latest_created_revision_name
}

output "run_entire_data_object" {
    value = data.google_cloud_run_service.run_service
}


# Reunning after making a change in step 04 makes no changes. Also, manually deploying a new revision to the new latest does not affect this terraform because it doesn't care about the hash.


# Question: what happens if i roll out a revision to something other than 100%?

# Answer: Terraform will break it by changing it back to 100% to latest.

# Bigger question: how is terraform expected to be used for Cloud Run services?  
## If you config revisions outside TF, it clobbers those changes
## If you want to manage revisions in TF, you can't unless you have a revision name


## Maybe you can use sha instead of "latest"?