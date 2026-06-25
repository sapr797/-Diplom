#!/bin/bash
set -e

echo " Deploying to Kubernetes..."

# Обновить образ в deployment
sed -i "s|image:.*|image: cr.yandex/$REGISTRY_ID/$IMAGE_NAME:$(git rev-parse --short HEAD)|g" Zad3/deployment.yaml

# Применить манифест
kubectl apply -f Zad3/deployment.yaml

# Ожидать готовности
kubectl rollout status deployment/test-app -n default --timeout=5m

echo "✅ Deployment successful!"
echo " Test App: http://<NODE_IP>:30080"
