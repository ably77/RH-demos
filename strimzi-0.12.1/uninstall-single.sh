#!/bin/bash

NAMESPACE=myproject

# Removing the producer
oc delete pod kafka-producer1 -n ${NAMESPACE}
oc delete pod kafka-producer2 -n ${NAMESPACE}

# Removing the consumer
oc delete pod kafka-consumer1 -n ${NAMESPACE}
oc delete pod kafka-consumer2 -n ${NAMESPACE}

# Removing Jobs
oc delete -f job1.yaml -n ${NAMESPACE}
oc delete -f job2.yaml -n ${NAMESPACE}
oc delete -f job3.yaml -n ${NAMESPACE}

# Remove Kafka Topics
oc delete -f my-topic1.yaml
oc delete -f my-topic2.yaml
oc delete -f my-topic3.yaml

# Delete Kafka Cluster
oc delete -f kafka-cluster-single.yaml -n ${NAMESPACE}

# Delete Prometheus:
oc delete -f alerting-rules.yaml -n ${NAMESPACE}
oc delete -f prometheus.yaml -n ${NAMESPACE}

# Delete Grafana:
oc delete -f grafana.yaml -n ${NAMESPACE}

# Remove Strimzi Operator
oc delete -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n ${NAMESPACE}
