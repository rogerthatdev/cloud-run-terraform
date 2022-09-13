#!/bin/bash
# this would be thrown into a cloud build trigger that goes off when file is merged on main
gcloud builds submit \
    --config=cloudbuild.yaml \
    --project="cloud-run-fafo-f241" \
    --substitutions=_REGION="us-central1"
