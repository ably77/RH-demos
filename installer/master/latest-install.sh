#!/bin/bash

export GOPATH=$HOME/go # don't forget to change your path correctly!
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

git clone https://github.com/openshift/installer.git $GOPATH/src/github.com/openshift/installer

$GOPATH/src/github.com/openshift/installer/hack/build.sh

mkdir $HOME/Desktop/ly-demo

cp $HOME/Desktop/installer/install-config.yaml $HOME/Desktop/ly-demo

$GOPATH/src/github.com/openshift/installer/bin/openshift-install create cluster --dir=$HOME/Desktop/ly-demo --log-level debug

git clone https://github.com/ably77/RH-demos.git $HOME/Desktop/ly-demo/RH-Demos
