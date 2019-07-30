#!/bin/bash

NAMESPACE=myproject

# Removing the consumer
oc delete pod kafka-consumer1 -n ${NAMESPACE}
oc delete pod kafka-consumer2 -n ${NAMESPACE}

# Removing Jobs
oc delete -f job1.yaml -n ${NAMESPACE}
oc delete -f job2.yaml -n ${NAMESPACE}
oc delete -f job3.yaml -n ${NAMESPACE}

# Removing Cron jobs
oc delete -f cron_job1.yaml -n ${NAMESPACE}
oc delete -f cron_job2.yaml -n ${NAMESPACE}
oc delete -f cron_job3.yaml -n ${NAMESPACE}

# Remove Kafka Topics
oc delete -f yaml/my-topic1.yaml
oc delete -f yaml/my-topic2.yaml
oc delete -f yaml/my-topic3.yaml

# Delete Kafka Cluster
oc delete -f yaml/kafka-cluster-3broker.yaml -n ${NAMESPACE}

# Delete Prometheus:
oc delete -f yaml/alerting-rules.yaml -n ${NAMESPACE}
oc delete -f yaml/prometheus.yaml -n ${NAMESPACE}

# Delete Grafana:
oc delete -f yaml/grafana.yaml -n ${NAMESPACE}

# Remove Strimzi Operator
oc delete -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n ${NAMESPACE}
