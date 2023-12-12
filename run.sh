#!/bin/bash

DEPLOY_CMD="./scripts/deploy.sh"
CLEAN_CMD=""

usage() {
  echo "Usage: $0 [-c]"
  echo "  -c  Run clean.sh before deploy.sh"
  exit 1
}

# Check for the -c flag
while getopts ":c" opt; do
  case $opt in
    c)
      # -c flag activated: run clean.sh before deploy.sh
      CLEAN_CMD="./scripts/clean.sh"
      ;;
    \?)
      # Invalid option
      echo "Invalid option: -$OPTARG"
      usage
      ;;
  esac
done

# Clean all deployments if -c flag is activated
if [ -n "$CLEAN_CMD" ]; then
  echo "Running clean.sh..."
  $CLEAN_CMD
fi

# Depoloy the kubernetes
echo "Running deploy.sh..."
$DEPLOY_CMD

exit 0
