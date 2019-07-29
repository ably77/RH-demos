#!/bin/bash

NAMESPACE=myproject

### Login as admin
oc login -u system:admin

### Create the project namespace
oc create namespace ${NAMESPACE}
oc project ${NAMESPACE}

### Apply Strimzi Installation File
oc apply -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n ${NAMESPACE}

### Provision the Apache Kafka Cluster
oc create -f yaml/kafka-cluster-3broker.yaml -n ${NAMESPACE}

### Create Kafka Topics
oc create -f yaml/my-topic1.yaml
oc create -f yaml/my-topic2.yaml
oc create -f yaml/my-topic3.yaml

### Start up your Prometheus server
oc create -f yaml/alerting-rules.yaml -n ${NAMESPACE}
oc create -f yaml/prometheus.yaml -n ${NAMESPACE}

### start up your Grafana server
oc create -f yaml/grafana.yaml -n ${NAMESPACE}

### Wait for grafana to deploy
./check-status-with-name.sh grafana myproject

echo
echo
echo "Point your browser to http://localhost:3000 once the port-forward is initiated and login using admin/admin"
echo

### Display grafana pod name
grafanapod=`oc get pods -n ${NAMESPACE} | awk 'NR > 1 { printf "%s\n", $1 }' | grep grafana`
oc port-forward -n ${NAMESPACE} $grafanapod 3000:3000
