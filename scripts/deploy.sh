#!/bin/bash

# Script to deploy all servises in the application

# Script is an amolgamation of course material, help from a friend and trial and error

# Set up message queue
kubectl apply -f kubernetes/redis-deployment.yaml

 # Set up postgres first and foremost
printf "Deploying postgres...\n"
kubectl apply -f kubernetes/postgres-deployment.yaml
kubectl apply -f kubernetes/postgres-pvc-pv.yaml
    
# Apply configmaps
printf "Deploying configmaps...\n"
kubectl apply -f kubernetes/configmaps.yaml

# Read the database ip
POSTGRES_IP=$(kubectl get service/postgres-service -o jsonpath='{.spec.clusterIP}')
printf "Postgres deployed. Binding postgres ip ($POSTGRES_IP) to flask-api and flask-user-management ConfigMap\n"

# Apply the database ip to the flask-api and flask-user-management configmaps
kubectl get configmap flask-api-config -o yaml \
    | sed -r "s/NOTSET/$POSTGRES_IP/" | kubectl apply -f -
        
kubectl get configmap flask-user-management-config -o yaml \
    | sed -r "s/NOTSET/$POSTGRES_IP/" | kubectl apply -f -


# Deploy flask-api and load balancer
printf "Deploying flask-api...\n"
kubectl apply -f kubernetes/flask-api-deployment.yaml

# Deploy flask-user-management and load balancer
printf "Deploying flask-user-management...\n"
kubectl apply -f kubernetes/flask-user-management-deployment.yaml

# Read the api and user manager ip - probably depreciated by the time of turn-in but I'm leaving it here
FLASK_API_IP=$(kubectl get service/flask-api-service\
                                            -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
FLASK_UM_IP=$(kubectl get service/flask-user-management-service \
                                            -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
printf "flask-api and flask-user-management deployed. Binding API ip ($FLASK_API_IP) and UM ip ($FLASK_UM_IP) to flask-ui ConfigMap\n"
kubectl get configmaps/flask-ui-config -o yaml \
    | sed -r "s/APIHOST/$FLASK_API_IP/" \
    | sed -r "s/UMHOST/$FLASK_UM_IP/" | kubectl apply -f -

# Finally, deploy flask-api and flask-user-management
printf "Deploying flask-ui...\n"
kubectl apply -f kubernetes/flask-ui-deployment.yaml 

