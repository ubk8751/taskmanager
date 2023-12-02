#!/bin/bash

# Script to completely reboot the application
# Usage: ./reboot.sh <tag>
#   <tag>: The tag to apply to the images in buildandpush

# Check if a tag argument is provided
if [ -z "$1" ]; then
    echo "Usage: ./reboot.sh <tag>"
    echo "  <tag>: The tag to apply to the images in buildandpush"
    exit 1
fi

# Assign the tag from the command line argument
tag=$1

# Clean up previous resources
echo "Cleaning up previous resources..."
./scripts/clean.sh

# Build and push images with the specified tag
echo "Building and pushing images with tag: ${tag}"
./scripts/buildandpush.sh ${tag}

# Deploy the application with the new images
echo "Deploying the application..."
./scripts/deploy.sh

echo "Application reboot complete."
