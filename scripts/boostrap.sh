#!/bin/bash

# Install ArgoCD
helm dep update ../charts/argo-cd/

# Deploy ArgoCD
helm install argo-cd ../charts/argo-cd/ --namespace argocd --create-namespace

# Wait for ArgoCD to be ready and execute a command to print argocd password
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd
kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" -n argocd | base64 -d

# Deploy ArgoCD Application of Applications
helm template ../charts/root-app/ | kubectl apply -f -