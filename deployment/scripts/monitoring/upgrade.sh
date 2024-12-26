#!/bin/bash
set -e

# Variables
NAMESPACE="monitoring"
VALUES_FILE="deployment/helm/kube-prometheus-stack/values.yml"

# Change to the terraform directory
cd deployment/terraform/loadgenerator

# Retrieve the Locust master IP address from Terraform output
LOCUST_EXPORTER_IP=$(terraform output -json locust_master_ips | jq -r '.[0]')

# Change to the root directory
cd ../../..

# Upgrade monitoring stack with the new scrape target configuration and dashboard import
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace ${NAMESPACE} -f ${VALUES_FILE} \
  --set prometheus.prometheusSpec.additionalScrapeConfigs[0].job_name='locust-exporter' \
  --set prometheus.prometheusSpec.additionalScrapeConfigs[0].static_configs[0].targets[0]="${LOCUST_EXPORTER_IP}:9646"

echo "Scrape target updated successfully"

