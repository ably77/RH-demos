#!/bin/bash

### Login as admin
oc login -u system:admin

### Apply Strimzi Installation File
oc apply -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n myproject

### Provision the Apache Kafka Cluster
oc apply -f kafka-cluster.yaml

### Start up your Prometheus server
oc create -f alerting-rules.yaml
oc create -f prometheus.yaml

### start up your Grafana server
oc create -f grafana.yaml
echo
echo "sleeping for 30 seconds to let grafana load"
echo
echo "Point your browser to http://localhost:3000 once the port-forward is initiated and login using admin/admin"
echo
sleep 30

### Display grafana pod name
grafanapod=`oc get pods | awk 'NR > 1 { printf "%s\n", $1 }' | grep grafana`
oc port-forward $grafanapod 3000:3000
