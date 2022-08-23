#!/bin/bash

gcloud builds submit -t gcr.io/${PROJECT}/hello-test .