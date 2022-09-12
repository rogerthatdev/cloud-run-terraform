#!/bin/bash
# this time build the same container twice.  Get the digest via `gcloud artifacts docker images list`
gcloud builds submit \
    --config=web-build.cloudbuild.yaml \
    --ignore-file=web-build.gcloudignore \
    --project="cloud-run-fafo-f241" --substitutions=_REGION="us-central1",_SHORT_SHA="blue"


gcloud builds submit \
    --config=web-build.cloudbuild.yaml \
    --ignore-file=web-build.gcloudignore \
    --project="cloud-run-fafo-f241" --substitutions=_REGION="us-central1",_SHORT_SHA="green"
