#!/bin/bash

source ./constants.sh

gcloud dataproc batches submit pyspark $1 \
  --batch=$2 \
  --region=${REGION} \
  --deps-bucket=gs://${BUCKET} \
  --history-server-cluster=projects/${GOOGLE_CLOUD_PROJECT}/regions/${REGION}/clusters/${PHS_CLUSTER_NAME} \
  -- ${BUCKET}