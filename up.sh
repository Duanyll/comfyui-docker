#!/usr/bin/env bash

echo "USER_UID=$UID" > .env
echo "USER_GID=$UID" >> .env

mkdir -p ./workspace
touch ./workspace/filebrowser.db

# Create docker volume hfhub_cache if it doesn't exist
if ! docker volume ls | grep -q hfhub_cache; then
    docker volume create hfhub_cache
fi

docker compose up -d