#!/bin/bash

# Function to display usage information
function show_usage {
    echo "Usage: ./scale.sh [-ui/-api/-um] -r <replicas>"
    echo "  -ui: Scale the flask-ui deployment"
    echo "  -api: Scale the flask-api deployment"
    echo "  -um: Scale the flask-user-management deployment"
    echo "  -r <replicas>: Number of replicas to scale to (integer)"
    exit 1
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    show_usage
fi

# Parse command-line options
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -ui)
            deployment="flask-ui"
            shift
            ;;
        -api)
            deployment="flask-api"
            shift
            ;;
        -um)
            deployment="flask-user-management"
            shift
            ;;
        -r)
            replicas="$2"
            shift
            shift
            ;;
        *)
            show_usage
            ;;
    esac
done

# Check if both deployment and replicas are provided
if [ -z "$deployment" ] || [ -z "$replicas" ]; then
    show_usage
fi

# Scale the deployment
kubectl scale deployment $deployment --replicas=$replicas

echo "Scaled $deployment deployment to $replicas replicas."
