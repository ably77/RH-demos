#!/bin/bash

# Removing the consumer
oc delete pod kafka-consumer1
oc delete pod kafka-consumer2

# Removing Jobs
oc delete -f job1.yaml
oc delete -f job2.yaml
oc delete -f job3.yaml

# Remove Kafka Topics
oc delete -f my-topic1.yaml
oc delete -f my-topic2.yaml
oc delete -f my-topic3.yaml

# Delete Kafka Cluster
oc delete -f kafka-cluster.yaml

# Delete Prometheus:
oc delete -f alerting-rules.yaml
oc delete -f prometheus.yaml

# Delete Grafana:
oc delete -f grafana.yaml

# Remove Strimzi Operator
oc delete -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n myproject
