#!/bin/bash

./openshift-install_4.3.2 destroy cluster --dir=$HOME/Desktop/<REPLACE_WITH_CLUSTER_NAME> --log-level debug

echo
echo END.
echo

read -p "Cluster gone? Remove the installer directory? (y/n) " -n1 -s c
if [ "$c" = "y" ]; then
        echo yes

rm -rf $HOME/Desktop/<REPLACE_WITH_CLUSTER_NAME>

fi
