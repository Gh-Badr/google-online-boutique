#!/bin/bash
set -e

# Variables
INVENTORY_FILE="deployment/ansible/inventory"
SSH_KEY_PATH="$HOME/.ssh/loadgenerator_id_rsa"

# Disable host key checking
export ANSIBLE_HOST_KEY_CHECKING=False

# Change to the terraform directory
cd deployment/terraform/loadgenerator

# Retrieve the VM IP addresses
MASTER_IPS=$(terraform output -json locust_master_ips | jq -r '.[]')
WORKER_IPS=$(terraform output -json locust_worker_ips | jq -r '.[]')

# Change to the root directory
cd ../../..

# Generate the inventory file
echo "[locust_master]" > ${INVENTORY_FILE}
for IP in ${MASTER_IPS}; do
  echo "${IP} ansible_user=root ansible_ssh_private_key_file=${SSH_KEY_PATH}" >> ${INVENTORY_FILE}
done
echo "[locust_workers]" >> ${INVENTORY_FILE}
for IP in ${WORKER_IPS}; do
  echo "${IP} ansible_user=root ansible_ssh_private_key_file=${SSH_KEY_PATH}" >> ${INVENTORY_FILE}
done

echo "Inventory file generated at ${INVENTORY_FILE}"

# Retrieve the external IP address of the frontend service
FRONTEND_IP=$(kubectl get svc frontend-external -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Run the Ansible playbooks
ansible-playbook -i ${INVENTORY_FILE} deployment/ansible/playbook_common.yml --extra-vars "frontend_ip=${FRONTEND_IP}"
ansible-playbook -i ${INVENTORY_FILE} deployment/ansible/playbook_master.yml --extra-vars "frontend_ip=${FRONTEND_IP}"
ansible-playbook -i ${INVENTORY_FILE} deployment/ansible/playbook_worker.yml --extra-vars "frontend_ip=${FRONTEND_IP}"

echo "Load generator VMs configured successfully."