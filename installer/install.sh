#!/bin/bash

CLUSTER_NAME=<insert cluster name here>

### clear kubeconfig
rm -rf ~/.kube/config

### create cluster directory
mkdir $HOME/Desktop/${CLUSTER_NAME}

### copy ignition into cluster directory
cp $HOME/Desktop/installer/install-config.yaml $HOME/Desktop/${CLUSTER_NAME}

### create cluster
./openshift-install_4.3.2 create cluster --dir=$HOME/Desktop/${CLUSTER_NAME} --log-level debug

### open console route
open https://console-openshift-console.apps.${CLUSTER_NAME}.openshiftaws.com

### setup ally user and login
export KUBECONFIG=$HOME/Desktop/${CLUSTER_NAME}/auth/kubeconfig
