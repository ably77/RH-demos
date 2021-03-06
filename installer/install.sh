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

### export kubeconfig
export KUBECONFIG=$HOME/Desktop/${CLUSTER_NAME}/auth/kubeconfig

### setup new tab for iterm2
newtabi(){
  osascript \
    -e 'tell application "iTerm2" to tell current window to set newWindow to (create tab with default profile)'\
    -e "tell application \"iTerm2\" to tell current session of newWindow to write text \"${@}\""
}

newtabi 'export KUBECONFIG=/Users/alexly/Desktop/ly-demo/auth/kubeconfig && cd $HOME/Desktop/openshift-testbed && ./runme.sh'
