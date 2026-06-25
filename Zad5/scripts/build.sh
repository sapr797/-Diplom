#!/bin/bash

set -e

IMAGE_NAME="test-app"
REGISTRY_ID=$(yc container registry list --format json | jq -r '.[0].id')

echo "🔨 Building Docker image..."
docker build -t cr.yandex/$REGISTRY_ID/$IMAGE_NAME:latest ./Zad3
docker tag cr.yandex/$REGISTRY_ID/$IMAGE_NAME:latest cr.yandex/$REGISTRY_ID/$IMAGE_NAME:$(git rev-parse --short HEAD)

echo "✅ Image built: cr.yandex/$REGISTRY_ID/$IMAGE_NAME:latest"
