#!/bin/bash

NAMESPACE=jenkins

oc new-project jenkins

oc new-app jenkins-ephemeral -n ${NAMESPACE}

### jenkins ephemeral
#oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/jenkins/jenkins-ephemeral-template.json -n openshift

### jenkins persistent
#oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/jenkins/jenkins-persistent-template.json -n openshift

### wait for build
./wait-for-build.sh jenkins ${NAMESPACE}

### open IoT demo app route
echo opening jenkins route
open https://$(oc get routes -n ${NAMESPACE} | grep jenkins | awk '{ print $2 }')

oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/jenkins/pipeline/nodejs-sample-pipeline.yaml

oc start-build nodejs-sample-pipeline

### wait for build
./wait-for-build.sh nodejs-mongodb-example ${NAMESPACE}

### open route
echo opening nodejs-sample route
open http://$(oc get routes -n ${NAMESPACE} | grep nodejs-mongodb-example | awk '{ print $2 }')
