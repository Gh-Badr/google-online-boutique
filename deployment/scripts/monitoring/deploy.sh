#!/bin/bash
set -e

# Variables
NAMESPACE="monitoring"
PROMETHEUS_VALUES_FILE="deployment/helm/prometheus/values.yml"
GRAFANA_VALUES_FILE="deployment/helm/grafana/values.yml"

# Create the monitoring namespace
kubectl create namespace ${NAMESPACE} || true # Ignore error if the namespace already exists

# Add the Prometheus Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Add the Grafana Helm repository
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install or upgrade Prometheus using the custom values file
helm upgrade --install prometheus prometheus-community/prometheus --namespace ${NAMESPACE} -f ${PROMETHEUS_VALUES_FILE}
helm upgrade --install grafana grafana/grafana --namespace ${NAMESPACE} -f ${GRAFANA_VALUES_FILE}

# Wait for Prometheus pods to be ready
kubectl wait --for=condition=ready pods --all -n ${NAMESPACE} --timeout=300s

echo "Prometheus deployed successfully."