#! /usr/bin/env bash

echo "Deploy devops-tools namespace"
kubectl apply -f ./namespace.yaml

echo "Deploy service account and roles, and role bindings"
kubectl apply -f ./service-account.yaml

echo "deploy the persistent volume and claim"
kubectl apply -f ./volume.yaml

echo "deploy the nodeport service"
kubectl apply -f ./service.yaml

echo "deploy Jenkins servicer"
kubectl apply -f ./deployment.yaml
