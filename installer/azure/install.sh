#!/bin/bash

mkdir $HOME/Desktop/ly-demo-azure

cp $HOME/Desktop/installer/azure/install-config-azure.yaml $HOME/Desktop/ly-demo-azure/install-config.yaml

./openshift-install_4.2.2 create cluster --dir=$HOME/Desktop/ly-demo-azure --log-level debug

git clone https://github.com/ably77/RH-demos.git $HOME/Desktop/ly-demo-azure/RH-Demos
