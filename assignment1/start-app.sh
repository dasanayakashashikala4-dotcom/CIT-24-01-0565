#!/bin/bash

set -e

NETWORK_NAME="wordpress-network"
DB_CONTAINER="wordpress-db"
APP_CONTAINER="wordpress-app"

echo "Starting application..."

# Make sure the required network and volume exist
if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Required network does not exist."
  echo "Please run ./prepare-app.sh first."
  exit 1
fi

if ! docker volume inspect wordpress-data >/dev/null 2>&1; then
  echo "Required volume does not exist."
  echo "Please run ./prepare-app.sh first."
  exit 1
fi

# Start or create MySQL container
if docker container inspect "$DB_CONTAINER" >/dev/null 2>&1; then
  if [ "$(docker inspect -f '{{.State.Running}}' "$DB_CONTAINER")" = "true" ]; then
    echo "MySQL container is already running."
  else
    docker start "$DB_CONTAINER"
    echo "Existing MySQL container started."
  fi
else
  docker run -d \
    --name "$DB_CONTAINER" \
    --network "$NETWORK_NAME" \
    --restart on-failure \
    -e MYSQL_ROOT_PASSWORD=root123 \
    -e MYSQL_DATABASE=wordpress \
    -e MYSQL_USER=wpuser \
    -e MYSQL_PASSWORD=wp123 \
    -v wordpress-data:/var/lib/mysql \
    mysql:8.0

  echo "MySQL container created and started."
fi

echo "Waiting for MySQL to become ready..."

until docker exec "$DB_CONTAINER" \
  mysqladmin ping -h localhost -uroot -proot123 --silent >/dev/null 2>&1
do
  sleep 3
done

echo "MySQL is ready."

# Start or create WordPress container
if docker container inspect "$APP_CONTAINER" >/dev/null 2>&1; then
  if [ "$(docker inspect -f '{{.State.Running}}' "$APP_CONTAINER")" = "true" ]; then
    echo "WordPress container is already running."
  else
    docker start "$APP_CONTAINER"
    echo "Existing WordPress container started."
  fi
else
  docker run -d \
    --name "$APP_CONTAINER" \
    --network "$NETWORK_NAME" \
    --restart on-failure \
    -p 5000:80 \
    -e WORDPRESS_DB_HOST=wordpress-db:3306 \
    -e WORDPRESS_DB_USER=wpuser \
    -e WORDPRESS_DB_PASSWORD=wp123 \
    -e WORDPRESS_DB_NAME=wordpress \
    wordpress:latest

  echo "WordPress container created and started."
fi

echo "=================================="
echo "Application started successfully!"
echo "Open the application at:"
echo "http://localhost:5000"
echo "=================================="
