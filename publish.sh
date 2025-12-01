#!/usr/bin/env bash
set -e

VERSION=$(grep -E '^version\s*=' pyproject.toml | sed -E 's/version\s*=\s*"([^"]+)"/\1/')

if [ -z "$VERSION" ]; then
    echo "❌ Could not extract version from pyproject.toml"
    exit 1
fi


echo "📦 Publishing version: v$VERSION"

git add .
git commit -m "Publish v$VERSION" || echo "✔ Nothing to commit"
git push

git tag -a "v$VERSION" -m "v$VERSION"
git push origin "v$VERSION"

echo "✅ Done! Published v$VERSION"
