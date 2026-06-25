#!/bin/bash

set -e

echo "🚀 Deploying to Kubernetes..."

kubectl apply -f ./k8s/configmap.yaml
kubectl apply -f ./k8s/deployment.yaml
kubectl apply -f ./k8s/service.yaml
kubectl apply -f ./k8s/ingress.yaml

kubectl rollout status deployment/test-app -n default --timeout=5m

echo "✅ Deployment successful!"
echo " Test App: http://<NODE_IP>:30080"
