#!/bin/bash
set -e

# Variables
NAMESPACE="monitoring"
VALUES_FILE="deployment/helm/kube-prometheus-stack/values.yml"

# Create the monitoring namespace
kubectl create namespace ${NAMESPACE} || true # Ignore error if the namespace already exists

# Add the prometheus-community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Deploy monitoring stack
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace ${NAMESPACE} -f ${VALUES_FILE}

# Wait for Prometheus pods to be ready
kubectl wait --for=condition=ready pods --all -n ${NAMESPACE} --timeout=300s

echo "Monitoring stack deployed successfully"