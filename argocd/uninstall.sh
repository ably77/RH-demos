#!/bin/bash

argo_namespace="argocd"
argo_route="argocd-server"
app_name="simple-app"

# delete app
argocd app delete ${app_name}

oc delete -f https://raw.githubusercontent.com/argoproj/argo-cd/v1.2.2/manifests/install.yaml -n ${argo_namespace}

oc delete routes ${argo_route}
