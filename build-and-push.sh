#!/bin/bash
set -e

# Registry config
REGISTRY="registry.sepradc.ovh"
PROJECT="homer"
VERSION=$(node -p "require('./package.json').version")

# Le registry demande une authentification (htpasswd) : réutilise les identifiants
# déjà enregistrés, ne demande le mot de passe que la première fois
echo "🔐 Login to registry..."
docker login $REGISTRY

# Le stage de build tourne sur l'archi de la machine ($BUILDPLATFORM), seul le stage
# final est en ARM64 : pas d'émulation QEMU pour pnpm build
echo "🏗️  Building Homer $VERSION for ARM64..."
docker buildx build \
  --platform linux/arm64 \
  --push \
  --build-arg VERSION_TAG="$VERSION" \
  -t $REGISTRY/$PROJECT:arm64 \
  -t $REGISTRY/$PROJECT:$VERSION \
  -t $REGISTRY/$PROJECT:latest \
  .

echo "✅ Image pushed successfully!"
echo ""
echo "Homer: $REGISTRY/$PROJECT:arm64 ($VERSION)"
