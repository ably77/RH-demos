#!/bin/bash

oc delete project ubi7-operator

oc delete -f deploy/role_binding.yaml \
          -f deploy/role.yaml \
          -f deploy/crds/ubi7-crd.yaml \
          -f storage/aws \
          -f storage/minishift
