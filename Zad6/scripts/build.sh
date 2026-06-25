#!/bin/bash

set -e

echo "🔨 Building Docker image..."

IMAGE_NAME="test-app"
REGISTRY_ID=$(yc container registry list --format json | jq -r '.[0].id')
TAG=${1:-latest}

docker build -t cr.yandex/$REGISTRY_ID/$IMAGE_NAME:$TAG ./docker

echo "✅ Image built: cr.yandex/$REGISTRY_ID/$IMAGE_NAME:$TAG"
