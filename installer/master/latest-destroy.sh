#!/bin/bash

export GOPATH=$HOME/go # don't forget to change your path correctly!
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

$GOPATH/src/github.com/openshift/installer/bin/openshift-install destroy cluster --dir=$HOME/Desktop/ly-demo --log-level debug

echo
echo END.
echo

read -p "Cluster gone? Remove the installer directory? (y/n) " -n1 -s c
if [ "$c" = "y" ]; then
        echo yes

rm -rf $GOPATH/src/github.com/openshift
rm -rf $HOME/Desktop/ly-demo

fi
