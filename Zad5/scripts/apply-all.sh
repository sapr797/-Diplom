#Скрипт для локального применения (если CI/CD не настроен)
#!/bin/bash

set -e

echo "🚀 Applying all Terraform configurations..."

# Apply Zad1
cd Zad1
terraform init
terraform apply -auto-approve

# Get backend config
terraform output -json backend_config > backend.json
BUCKET=$(cat backend.json | jq -r '.bucket')
ACCESS_KEY=$(cat backend.json | jq -r '.access_key')
SECRET_KEY=$(cat backend.json | jq -r '.secret_key')

# Apply Zad2
cd ../Zad2
terraform init -backend-config="bucket=$BUCKET" \
               -backend-config="access_key=$ACCESS_KEY" \
               -backend-config="secret_key=$SECRET_KEY"
terraform apply -auto-approve

echo "✅ All infrastructure applied!"

# Get kubeconfig
terraform output -raw kubeconfig > kubeconfig
export KUBECONFIG=$(pwd)/kubeconfig

# Deploy monitoring
cd ../Zad4
chmod +x install.sh
./install.sh

# Deploy test app
kubectl apply -f ../Zad3/deployment.yaml

echo "✅ All services deployed!"
echo "📊 Access Grafana: http://<NODE_IP>:30090"
echo "📊 Access Test App: http://<NODE_IP>:30080"
