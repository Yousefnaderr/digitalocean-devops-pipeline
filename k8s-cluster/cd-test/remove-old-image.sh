#!/bin/bash

REPO_NAME="backend"
REGISTRY="swipebay-registry"
TOKEN="$DO_ACCESS_TOKEN"

doctl auth init -t "$TOKEN" >/dev/null 2>&1
doctl registry login >/dev/null 2>&1

TAGS=$(doctl registry repository list-tags $REPO_NAME --format Tag --no-header)
SHA_TAGS=$(echo "$TAGS" | grep -E '^[a-f0-9]{6,8}$')

if [ -z "$SHA_TAGS" ]; then
  echo "✅ No SHA-based images found."
  exit 0
fi

for TAG in $SHA_TAGS; do
  DIGEST=$(doctl registry repository list-manifests $REPO_NAME --format Digest,Tags --no-header | grep "$TAG" | awk '{print $1}')
  if [[ -n "$DIGEST" ]]; then
    doctl registry repository delete-manifest --force $REPO_NAME "$DIGEST"
  fi
done

echo "✅ Cleanup done."

