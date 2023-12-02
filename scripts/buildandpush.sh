#!/bin/bash

# Script to build the docker containers, tag them and then push it to dockerhub
#   tag: str
#       The tag to apply to the image

tag=$1

echo "Building docker container..."
docker-compose build --no-cache

echo "Tagging docker containers..."
docker tag taskmanager-flask-api ubk8751/flask-api:${tag}
docker tag taskmanager-flask-user-management ubk8751/flask-user-management:${tag}
docker tag taskmanager-flask-ui ubk8751/flask-ui:${tag}

echo "Pushing to docker hub..."
docker push ubk8751/flask-api:${tag}
docker push ubk8751/flask-user-management:${tag}
docker push ubk8751/flask-ui:${tag}