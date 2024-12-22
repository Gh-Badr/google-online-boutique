#!/bin/bash
set -e

# Check if a project ID is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project_id>"
  exit 1
fi

# Variables
PROJECT_ID="$1"
SSH_KEY_PATH="$HOME/.ssh/loadgenerator_id_rsa"

# Change to the terraform directory
cd deployment/terraform/loadgenerator

# Initialize Terraform
terraform init

# Apply Terraform configuration with the provided project ID
terraform apply -var="gcp_project_id=${PROJECT_ID}" -auto-approve

# Retrieve the private key and save it to ~/.ssh/id_rsa
PRIVATE_KEY=$(terraform output -raw private_key)
echo "${PRIVATE_KEY}" > ${SSH_KEY_PATH}
chmod 600 ${SSH_KEY_PATH}