#!/bin/bash

set -e

NETWORK_NAME="wordpress-network"
VOLUME_NAME="wordpress-data"

echo "Preparing application..."

# Create Docker network if it does not already exist
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Network '$NETWORK_NAME' already exists."
else
  docker network create "$NETWORK_NAME"
  echo "Network '$NETWORK_NAME' created."
fi

# Create persistent volume if it does not already exist
if docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
  echo "Volume '$VOLUME_NAME' already exists."
else
  docker volume create "$VOLUME_NAME"
  echo "Volume '$VOLUME_NAME' created."
fi

# Pull WordPress image if missing
if docker image inspect wordpress:latest >/dev/null 2>&1; then
  echo "WordPress image already exists."
else
  docker pull wordpress:latest
fi

# Pull MySQL image if missing
if docker image inspect mysql:8.0 >/dev/null 2>&1; then
  echo "MySQL image already exists."
else
  docker pull mysql:8.0
fi

echo "=================================="
echo "Application preparation completed!"
echo "=================================="
