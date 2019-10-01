#!/bin/bash

./import.sh

oc new-project ubi7-operator

oc create -f deploy/crds/ubi7-crd.yaml

oc create -f deploy/operator.yaml \
          -f deploy/role_binding.yaml \
          -f deploy/role.yaml \
          -f deploy/service_account.yaml

./check-pod-status.sh ubi7-operator ubi7-operator

#oc create -f storage/aws
oc create -f storage/minishift

oc create -n ubi7-operator -f deploy/crds/ubi7-cr.yaml
