#!/bin/bash

CLUSTER_NAME= "ly-demo"

CLUSTER_PATH= "$HOME/Desktop"

./openshift-install_4.3.2 destroy cluster --dir=${CLUSTER_PATH}/${CLUSTER_NAME} --log-level debug

echo
echo END.
echo

read -p "Cluster gone? Remove the installer directory? (y/n) " -n1 -s c
if [ "$c" = "y" ]; then
        echo yes

rm -rf ${CLUSTER_PATH}/${CLUSTER_NAME}

fi
