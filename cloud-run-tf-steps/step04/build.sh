#!/bin/bash

# Running this a second time should only create a new build image but not affect the run service

gcloud builds submit \
    --config=web-build.cloudbuild.yaml \
    --ignore-file=web-build.gcloudignore \
    --project="cloud-run-fafo-f241" --substitutions=_REGION="us-central1",_SHORT_SHA="latest"


