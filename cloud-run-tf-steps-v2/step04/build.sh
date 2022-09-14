#!/bin/bash

gcloud builds submit \
    --config=web-build.cloudbuild.yaml \
    --ignore-file=web-build.gcloudignore \
    --project="cloud-run-fafo-f241" --substitutions=_REGION="us-central1",_SHORT_SHA="canary"


