#!/bin/bash

echo "Stopping application..."

docker stop wordpress-app
docker stop wordpress-db

echo "=================================="
echo "Application stopped successfully!"
echo "=================================="
