#!/bin/bash
set -e

# Variables
INVENTORY_FILE="deployment/ansible/inventory"

# Change to the terraform directory
cd deployment/terraform/loadgenerator

# Retrieve the VM IP address
VM_IP=$(terraform output -raw loadgenerator_vm_ip)

# Change to the root directory
cd ../../..

# Generate the inventory file
cat <<EOF > ${INVENTORY_FILE}
[loadgenerator]
${VM_IP} ansible_user=root ansible_ssh_private_key_file=~/.ssh/loadgenerator_id_rsa
EOF

echo "Inventory file generated at ${INVENTORY_FILE}"

# Retrieve the external IP address of the frontend service
FRONTEND_IP=$(kubectl get svc frontend-external -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Run the Ansible playbook
ansible-playbook -i ${INVENTORY_FILE} deployment/ansible/playbook.yml --extra-vars "frontend_ip=${FRONTEND_IP}"

echo "Load generator VM configured successfully."