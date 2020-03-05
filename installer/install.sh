#!/bin/bash

### clear kubeconfig
rm -rf ~/.kube/config

### create cluster directory
mkdir $HOME/Desktop/<REPLACE_WITH_CLUSTER_NAME>

### copy ignition into cluster directory
cp $HOME/Desktop/installer/install-config.yaml $HOME/Desktop/<REPLACE_WITH_CLUSTER_NAME>

### create cluster
./openshift-install_4.3.2 create cluster --dir=$HOME/Desktop/<REPLACE_WITH_CLUSTER_NAME> --log-level debug

### open console route
open https://console-openshift-console.apps.<REPLACE_WITH_CLUSTER_NAME>.openshiftaws.com

### setup ally user and login
export KUBECONFIG=$HOME/Desktop/<REPLACE_WITH_CLUSTER_NAME>/auth/kubeconfig
