#!/bin/bash
set -e

# Check if a project ID is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project_id>"
  exit 1
fi

# Variables
PROJECT_ID="$1"
REPO_URL="https://github.com/Gh-Badr/microservices-demo.git"
CLONE_DIR="/tmp/microservices-demo"
NAMESPACE="default"
FILEPATH_MANIFEST="kustomize/"

# Change to the terraform directory
cd deployment/terraform

# Retrieve the cluster name and zone from Terraform outputs
CLUSTER_NAME=$(terraform output -raw cluster_name)
CLUSTER_ZONE=$(terraform output -raw cluster_location)

# Get credentials for the GKE cluster
gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${CLUSTER_ZONE} --project ${PROJECT_ID}

# Clone the repository if the directory does not already exist
if [ ! -d "${CLONE_DIR}" ]; then
  git clone ${REPO_URL} ${CLONE_DIR}
fi

# Change to the kustomize directory
cd ${CLONE_DIR}/${FILEPATH_MANIFEST}

# Apply the Kubernetes manifests
kubectl apply -k . -n ${NAMESPACE}

# Wait for all Pods to be ready
kubectl wait --for=condition=ready pods --all -n ${NAMESPACE} --timeout=300s

# Clean up
rm -rf ${CLONE_DIR}

echo "Application deployed successfully."