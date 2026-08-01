#!/bin/bash

set -e

echo "Removing application..."

# Stop containers if they are running
docker rm -f wordpress-app 2>/dev/null || true
docker rm -f wordpress-db 2>/dev/null || true

# Remove network
docker network rm wordpress-network 2>/dev/null || true

# Remove persistent volume
docker volume rm wordpress-data 2>/dev/null || true

# Remove Docker images
docker image rm wordpress:latest 2>/dev/null || true
docker image rm mysql:8.0 2>/dev/null || true

echo "=================================="
echo "Application removed successfully!"
echo "=================================="
