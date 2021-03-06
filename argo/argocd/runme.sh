#!/bin/bash

# argo deployment varaiables
argo_namespace="argocd"
new_password="secret"
argo_version="1.3.6"

# demo app deployment variables
argo_project="default"
app_name="simple-app"
app_namespace="default"
repo_url="https://github.com/ably77/argocd-demo"
sync_policy="none"

# Create a new namespace for ArgoCD components
oc new-project ${argo_namespace}

# Apply the ArgoCD Install Manifest
oc apply -f https://raw.githubusercontent.com/argoproj/argo-cd/v${argo_version}/manifests/install.yaml -n ${argo_namespace}

./extras/wait-for-condition.sh argocd-server ${argo_namespace}

# Get the ArgoCD Server password
argocd_server_password=$(oc -n ${argo_namespace} get pod -l "app.kubernetes.io/name=argocd-server" -o jsonpath='{.items[*].metadata.name}')

# patch ArgoCD Server so no TLS is configured on the server (--insecure)
patch='{"spec":{"template":{"spec":{"$setElementOrder/containers":[{"name":"argocd-server"}],"containers":[{"command":["argocd-server","--insecure","--staticassets","/shared/app"],"name":"argocd-server"}]}}}}'

oc -n ${argo_namespace} patch deployment argocd-server -p $patch

# Expose the ArgoCD Server using an Edge OpenShift Route so TLS is used for incoming connections
oc -n ${argo_namespace} create route edge argocd-server --service=argocd-server --port=http --insecure-policy=Redirect

# Get ArgoCD Server Route Hostname
argocd_route=$(oc -n ${argo_namespace} get route argocd-server -o jsonpath='{.spec.host}')

# sleep - automate this
echo sleeping 75 seconds to wait for route creation to complete
sleep 75

# Login with the current admin password
argocd --insecure --grpc-web login ${argocd_route}:443 --username admin --password ${argocd_server_password}

# Update admin's password
argocd --insecure --grpc-web --server ${argocd_route}:443 account update-password --current-password ${argocd_server_password} --new-password ${new_password}

# Open route
open http://${argocd_route}

# Add repo to be managed to argo repositories
argocd repo add ${repo_url}

# Create argo app
./extras/create-app.sh ${argo_project} ${app_name} ${repo_url} ${app_namespace} ${sync_policy}

# Dry run
argocd app sync ${app_name} --dry-run

# Deploy app
argocd app sync ${app_name}

# Setup sync policy and prune
argocd app set ${app_name} --sync-policy automated --auto-prune

# watch pod creation
oc get pods -n ${app_namespace} -w
