#!/bin/bash

set -e

VERSION=${1:-v1.0.0}

echo "🚀 Creating release $VERSION..."

# Build and push
./scripts/build.sh $VERSION
./scripts/push.sh $VERSION

# Update deployment
sed -i "s|image:.*|image: cr.yandex/$REGISTRY_ID/test-app:$VERSION|g" ./k8s/deployment.yaml

# Deploy
./scripts/deploy.sh

echo "✅ Release $VERSION complete!"
