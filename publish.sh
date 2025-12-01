#!/usr/bin/env bash
set -euo pipefail

# Extract version from pyproject.toml (supports indent)
VERSION=$(grep -E '^[[:space:]]*version\s*=' pyproject.toml \
  | sed -E 's/.*version\s*=\s*"([^"]+)".*/\1/')

if [[ -z "$VERSION" ]]; then
    echo "❌ Could not extract version from pyproject.toml"
    exit 1
fi

TAG="v$VERSION"
TAG_MSG="V$VERSION"

echo "📦 Publishing version: $TAG"

git add .
git commit -m "Publish $TAG" || echo "✔ Nothing to commit"
git push

# Create tag only if it does not exist
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "⚠️ Tag $TAG already exists! Skipping tag creation."
else
    git tag -a "$TAG" -m "$TAG_MSG"
    git push origin "$TAG"
fi

echo "✅ Done! Published $TAG"
