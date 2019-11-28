#!/bin/bash

namespace=argocd

oc delete -f https://raw.githubusercontent.com/argoproj/argo-cd/v1.2.2/manifests/install.yaml -n ${namespace}

oc delete routes argocd-server
