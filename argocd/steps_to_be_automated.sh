#!/bin/bash

namespace=argocd
NEW_PASSWORD=secret
app_name=simple-app

# Create a new namespace for ArgoCD components
oc new-project ${namespace}

# Apply the ArgoCD Install Manifest
oc apply -f https://raw.githubusercontent.com/argoproj/argo-cd/v1.2.2/manifests/install.yaml -n ${namespace}

./wait-for-condition.sh argocd-server ${namespace}

# Get the ArgoCD Server password
ARGOCD_SERVER_PASSWORD=$(oc -n ${namespace} get pod -l "app.kubernetes.io/name=argocd-server" -o jsonpath='{.items[*].metadata.name}')

# Patch ArgoCD Server so no TLS is configured on the server (--insecure)
PATCH='{"spec":{"template":{"spec":{"$setElementOrder/containers":[{"name":"argocd-server"}],"containers":[{"command":["argocd-server","--insecure","--staticassets","/shared/app"],"name":"argocd-server"}]}}}}'
oc -n ${namespace} patch deployment argocd-server -p $PATCH

# Expose the ArgoCD Server using an Edge OpenShift Route so TLS is used for incoming connections
oc -n ${namespace} create route edge argocd-server --service=argocd-server --port=http --insecure-policy=Redirect

# Get ArgoCD Server Route Hostname
ARGOCD_ROUTE=$(oc -n ${namespace} get route argocd-server -o jsonpath='{.spec.host}')

# Login with the current admin password
argocd --insecure --grpc-web login ${ARGOCD_ROUTE}:443 --username admin --password ${ARGOCD_SERVER_PASSWORD}

# Update admin's password
argocd --insecure --grpc-web --server ${ARGOCD_ROUTE}:443 account update-password --current-password ${ARGOCD_SERVER_PASSWORD} --new-password ${NEW_PASSWORD}

# Add repo to be managed to argo repositories
argocd repo add https://github.com/ably77/argocd-demo

# Create argo app
./extras/create-app.sh

# Dry run
argocd app sync ${app_name} --dry-run

# If dry-run is successful then deploy app
argocd app sync ${app_name}

# Setup sync policy and prune
argocd app set ${app_name} --sync-policy automated --auto-prune
