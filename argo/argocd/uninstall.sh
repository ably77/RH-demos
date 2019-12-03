#!/bin/bash

# argo deployment varaiables
argo_namespace="argo"
argo_route="argocd-server"
app_name="simple-app"
argo_version="1.3.0"

# delete app
argocd app delete ${app_name}

oc delete -f https://raw.githubusercontent.com/argoproj/argo-cd/v${argo_version}/manifests/install.yaml -n ${argo_namespace}

oc delete routes ${argo_route}
