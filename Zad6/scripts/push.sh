#!/bin/bash

set -e

echo "📤 Pushing Docker image..."

IMAGE_NAME="test-app"
REGISTRY_ID=$(yc container registry list --format json | jq -r '.[0].id')
TAG=${1:-latest}

yc container registry configure-docker
docker push cr.yandex/$REGISTRY_ID/$IMAGE_NAME:$TAG

echo "✅ Image pushed: cr.yandex/$REGISTRY_ID/$IMAGE_NAME:$TAG"
