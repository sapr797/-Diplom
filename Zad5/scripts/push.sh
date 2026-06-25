#!/bin/bash
set -e

IMAGE_NAME="test-app"
REGISTRY_ID=$(yc container registry list --format json | jq -r '.[0].id')

echo "📤 Pushing Docker image..."

# Аутентификация в YCR
yc container registry configure-docker

# Публикация
docker push cr.yandex/$REGISTRY_ID/$IMAGE_NAME:latest
docker push cr.yandex/$REGISTRY_ID/$IMAGE_NAME:$(git rev-parse --short HEAD)

echo "✅ Image published: cr.yandex/$REGISTRY_ID/$IMAGE_NAME:latest"
