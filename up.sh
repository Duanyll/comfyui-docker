#!/usr/bin/env bash

echo "USER_UID=$UID" > .env
echo "USER_GID=$UID" >> .env

mkdir -p ./workspace
touch ./workspace/filebrowser.db

docker compose up -d