#!/bin/bash

### Clone latest etcd-operator repo
git clone https://github.com/coreos/etcd-operator.git

### Create a new project
oc new-project etcd-operators

### Create role and rolebindings
./etcd-operator/example/rbac/create_role.sh --namespace=etcd-operators

### Create operator deployment
oc create -f ./etcd-operator/example/deployment.yaml

### Create etcd cluster deployment
oc create -f ./etcd-operator/example/example-etcd-cluster.yaml

### Watch pod creation
watch oc get pods
