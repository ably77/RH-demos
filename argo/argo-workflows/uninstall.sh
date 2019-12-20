#!/bin/bash

# argo deployment varaiables
argo_namespace="argo"
argowf_version="2.4.3"

# delete ConfigMap
oc delete -f extras/workflow-configmap.yaml

# delete app
oc delete -n ${argo_namespace} -f https://raw.githubusercontent.com/argoproj/argo/v${argowf_version}/manifests/install.yaml
