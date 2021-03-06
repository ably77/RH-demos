#!/bin/bash

NAMESPACE=myproject

# Removing the producer
oc delete pod kafka-producer1 -n ${NAMESPACE}
oc delete pod kafka-producer2 -n ${NAMESPACE}

# Removing the consumer
oc delete pod kafka-consumer1 -n ${NAMESPACE}
oc delete pod kafka-consumer2 -n ${NAMESPACE}

# Removing Jobs
oc delete -f yaml/job1.yaml -n ${NAMESPACE}
oc delete -f yaml/job2.yaml -n ${NAMESPACE}
oc delete -f yaml/job3.yaml -n ${NAMESPACE}

# Remove Kafka Topics
oc delete -f yaml/my-topic1.yaml
oc delete -f yaml/my-topic2.yaml
oc delete -f yaml/my-topic3.yaml

# Delete Kafka Cluster
oc delete -f yaml/kafka-cluster-single.yaml -n ${NAMESPACE}

# Delete Prometheus:
oc delete -f yaml/alerting-rules.yaml -n ${NAMESPACE}
oc delete -f yaml/prometheus.yaml -n ${NAMESPACE}

# Delete Grafana:
oc delete -f yaml/grafana.yaml -n ${NAMESPACE}

# Remove Strimzi Operator
oc delete -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n ${NAMESPACE}
