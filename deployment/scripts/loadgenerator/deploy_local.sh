#!/bin/bash
set -e

# Variables
REPO_URL="https://github.com/Gh-Badr/microservices-demo.git"
CLONE_DIR="/tmp/microservices-demo"
FILEPATH="src/loadgenerator/"

# Clone the repository if the directory does not already exist
if [ ! -d "${CLONE_DIR}" ]; then
  git clone ${REPO_URL} ${CLONE_DIR}
fi

# Change to the load generator directory
cd ${CLONE_DIR}/${FILEPATH}

# Get the external IP address of the frontend service
EXTERNAL_IP=$(kubectl get svc frontend-external -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Build the load generator Docker image, passing the external IP address as a build argument
docker build --build-arg FRONTEND_ADDR=${EXTERNAL_IP} -t loadgenerator .

# Run the load generator Docker container
docker run -d --name loadgenerator -p 8089:8089 loadgenerator

# Clean up
rm -rf ${CLONE_DIR}

echo "Load generator deployed on local successfully."