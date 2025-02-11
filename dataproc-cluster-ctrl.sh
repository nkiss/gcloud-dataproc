#!/bin/bash

source ./constants.sh

fail() {
    "ERROR: $1"
    exit 1
}

create_bq_dataset() {
    echo "Checking dataset existance ${DATASET}"
    bq ls ${DATASET} || \
    { \
    echo "Create a BigQuery dataset ${DATASET} to store data"; \
    bq --location=${REGION} mk -d ${DATASET} || fail "Couldn't create dataset"; \
    }
}

delete_dataset() {
    bq ls ${DATASET} && \
    { \
    echo "Delete BigQuery dataset ${DATASET} to store data"; \
    bq --location=${REGION} rm ${DATASET} || fail "Couldn't delete dataset"; \
    }
}

create_bucket() {
    echo "Checking bucket existance ${BUCKET}"
    gcloud storage ls gs://${BUCKET} || \
    { \
        echo "Create a Bucket ${BUCKET}"; \    
        gcloud storage buckets create gs://${BUCKET} --location=${REGION} || fail "Couldn't create bucket"; \
    } 
}

delete_bucket() {
    gcloud storage ls gs://${BUCKET} --buckets && \
    { \
        echo "Delete a Bucket ${BUCKET}"; \    
        gcloud storage buckets delete gs://${BUCKET} || fail "Couldn't create bucket"; \
    }
}

create_phs_cluster() {
    echo "Create PHS cluster"
    gcloud dataproc clusters create ${PHS_CLUSTER_NAME} \
        --region=${REGION} \
        --single-node \
        --enable-component-gateway \
        --properties=spark:spark.history.fs.logDirectory=gs://${BUCKET}/phs/*/spark-job-history \
        --max-idle=2h || fail "Couldn't create cluster"
    echo "PHS cluster will be deleted when not used."
}

# Function to execute when --up is provided
up() {
    echo "Configure the gcloud commands to use your current project's ID"
    gcloud config set project ${GOOGLE_CLOUD_PROJECT}
    
    echo "Verify that Google Private Access is enabled on the default subnet in your selected region."
    private_access_enabled = $(gcloud compute networks subnets describe default \
  --region=${REGION} \
  --format="get(privateIpGoogleAccess)")
    if [[ $private_access_enabled=="True" ]]; then
        echo "Private access enabled"
    else
        echo "Private access NOT enabled"
        exit 1
    fi
    
    echo "Verify that BigQuery GCloud services are enabled"
    gcloud services list | grep bigquery.googleapis.com || gcloud services enable bigquery.googleapis.com

    echo "Verify that Ddataproc GCloud services are enabled"
    gcloud services list | grep dataproc.googleapis.com || gcloud services enable dataproc.googleapis.com

    echo "Verify bucket ${BUCKET}"
    gcloud storage ls gs://${BUCKET} --buckets || create_bucket

    create_bq_dataset

    create_phs_cluster
}

# Function to execute when --down is provided
down() {
    echo "Clean up project ${GOOGLE_CLOUD_PROJECT}"

    delete_bucket 
    
    delete_dataset
}

# Check the input argument
case "$1" in
    --up)
        up
        ;;
    --down)
        down
        ;;
    *)
        echo "Usage: $0 --up | --down"
        exit 1
        ;;
esac
