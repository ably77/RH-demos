#!/bin/bash

argo_project="default"
app_name="simple-app"
repo_url="https://github.com/ably77/argocd-demo"
namespace="argocd"
sync_policy="none"

argocd app create --project ${argo_project} \
--name ${app_name} --repo ${repo_url} \
--path . --dest-server https://kubernetes.default.svc \
--dest-namespace ${namespace} --revision master --sync-policy ${sync_policy}
