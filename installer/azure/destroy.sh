#!/bin/bash

./openshift-install_4.2.2 destroy cluster --dir=$HOME/Desktop/ly-demo-azure --log-level debug

echo
echo END.
echo

read -p "Cluster gone? Remove the installer directory? (y/n) " -n1 -s c
if [ "$c" = "y" ]; then
        echo yes

rm -rf $HOME/Desktop/ly-demo-azure

fi
