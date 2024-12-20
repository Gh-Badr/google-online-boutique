#!/bin/bash
set -e

# Check if a project ID is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project_id>"
  exit 1
fi

# Variables
PROJECT_ID="$1"
SERVICE_ACCOUNT_NAME="gcp-infra-deployer-sa"
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
KEY_FILE_PATH="~/terraform-key.json"

# Check if the user is already authenticated
if gcloud auth application-default print-access-token &>/dev/null; then
  echo "Already authenticated with Google Cloud."
else
  echo "Authenticating with Google Cloud..."
  gcloud auth application-default login
fi

# Check if the service account already exists
EXISTING_ACCOUNT=$(gcloud iam service-accounts list --project=${PROJECT_ID} --filter="email:${SERVICE_ACCOUNT_EMAIL}" --format="value(email)")

if [ -z "${EXISTING_ACCOUNT}" ]; then
  echo "Service account does not exist. Creating service account..."
  gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME} --display-name "Terraform Service Account"
  gcloud projects add-iam-policy-binding ${PROJECT_ID} --member "serviceAccount:${SERVICE_ACCOUNT_EMAIL}" --role "roles/owner"
  gcloud iam service-accounts keys create ${KEY_FILE_PATH} --iam-account ${SERVICE_ACCOUNT_EMAIL}
  export GOOGLE_APPLICATION_CREDENTIALS=${KEY_FILE_PATH}
else
  echo "Service account already exists: ${EXISTING_ACCOUNT}"
fi

# Export the service account key file path
export GOOGLE_APPLICATION_CREDENTIALS=${KEY_FILE_PATH}

echo "Setup completed successfully."