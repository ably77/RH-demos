# Openshift Strimzi Kafka Operator Demo - Single Node Deployment (Minishift)

## Overview
Apache Kafka is a highly scalable and performant distributed event streaming platform great for storing, reading, and analyzing streaming data. Originally created at LinkedIn, the project was open sourced to the Apache Foundation in 2011. Kafka enables companies looking to move from traditional batch processes over to more real-time streaming use cases.

![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/architecture1.jpg)

The diagram above is a common example of many fast-data (streaming) solutions today. With kafka as a core component of your architecture, multiple raw data sources can pipe data to Kafka, be analyzed in real-time by tools such as Apache Spark, and persisted or consumed by other microservices

### Kubernetes Operators
An Operator is a method of packaging, deploying and managing a Kubernetes application. A Kubernetes application is an application that is both deployed on Kubernetes and managed using the Kubernetes APIs and kubectl tooling. With Operators, the kubernetes community gains a standardized way to build, deploy, operate, upgrade, and troubleshoot Kubernetes applications.

The full list of Operators can be found on [operatorhub.io](https://operatorhub.io/), the home for the Kubernetes community to share Operators.

### Strimzi Kafka Operator
Today we will be using the [strimzi.io](https://operatorhub.io/operator/strimzi-kafka-operator) Kafka Operator. Strimzi makes it easy to run Apache Kafka on OpenShift or Kubernetes.

Strimzi provides three operators:

Cluster Operator
Responsible for deploying and managing Apache Kafka clusters within an OpenShift or Kubernetes cluster.

Topic Operator
Responsible for managing Kafka topics within a Kafka cluster running within an OpenShift or Kubernetes cluster.

User Operator
Responsible for managing Kafka users within a Kafka cluster running within an OpenShift or Kubernetes cluster.


## Prerequisites:
- Minishift / Local Kubernetes Cluster
- Admin Privileges (i.e. cluster-admin RBAC privileges or logged in as system:admin user)

## Running this Demo
If you have an Openshift cluster up and are authenticated to the CLI, just run the command below. If you prefer to run through the commands manually, the instructions are in the section below.
```
./runme.sh
```

This quick script will:
- Login to Openshift as an admin
- Deploy the Strimzi Kafka Operator
- Deploy an ephemeral kafka cluster with 2 broker nodes
- Create three Kafka topics (my-topic1, my-topic2, my-topic3)
- Deploy Prometheus
- Deploy Grafana
- Forward port 3000 to localhost for Grafana

Open Grafana and login as `admin/admin`
```
open http://localhost:3000
```

From there, follow the instructions in the "Monitoring using Prometheus and Grafana" section to login to Grafana and configure your data sources and graphs. Afterwards, proceed to the demo section.

## Manual Installation Steps:

### Login as Admin
```
oc login -u system:admin
```

### Create the myproject namespace
```
oc create namespace myproject
```

### Apply Strimzi Installation File
Next we apply the Strimzi install files, including `ClusterRoles`, `ClusterRoleBindings` and some Custom Resource Definitions (`CRDs`). The CRDs define the schemas used for declarative management of the Kafka cluster, Kafka topics and users.

```
oc apply -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n myproject
```

### Provision the Apache Kafka Cluster
After that we feed Strimzi with a simple Custom Resource, which will than give you a small persistent Apache Kafka Cluster with one node for each, Apache Zookeeper and Apache Kafka:

For our demo we will be using a single kafka broker that uses ephemeral storage and exposes Prometheus metrics:
```
oc apply -f kafka-cluster-single.yaml -n myproject
```

We can now watch the deployment on the myproject namespace, and see all required pods being created:
```
oc get pods -n myproject -w
```

Once complete, the installation should look similar to below:
```
$ oc get pods -n myproject
my-cluster-entity-operator-6bc7f6985c-q29p5   3/3     Running   0          44s
my-cluster-kafka-0                            2/2     Running   1          91s
my-cluster-zookeeper-0                        2/2     Running   0          2m30s
strimzi-cluster-operator-78f8bf857-kpmhb      1/1     Running   0          3m10s
```

### Create Topics
Now that your cluster is up, you can create Kafka topics to which producers and consumers will subscribe to
```
oc create -f my-topic1.yaml
oc create -f my-topic2.yaml
```

## Monitoring using Prometheus and Grafana
First start up your Prometheus server:
```
oc create -f alerting-rules.yaml -n myproject
oc create -f prometheus.yaml -n myproject
```

Then start your Grafana server:
```
oc create -f grafana.yaml -n myproject
```

Access the grafana dashboard by using port-forwarding. First get the name of your Grafana Pod using `oc get pods` and then replace the pod name like the command below
```
oc port-forward <grafana-6b59f9886c-7sccm> 3000:3000
```

You should now be able to access your Grafana dashboard
```
open http://localhost:3000
```

Login using (admin/admin)
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana1.png)

Click on the "Add data Source" icon in the Grafana Homepage
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana2.png)

Add Prometheus as a datasource, specifying the information below and select Save & Test at the bottom
```
Name: prometheus
Type: Prometheus
URL: http://prometheus:9090
```

![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana4.png)

From the top left menu, click on "Dashboards" and then "Import" to open the "Import Dashboard" window
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana5.png)

Paste/import the contents of `kafka-dashboard.json` located in the Dashboards directory of this repo
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana6.png)

Select Prometheus in the drop-down as your data-source
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana7.png)

Now, repeat these steps for importing the Zookeeper dashboard

Once you're done you should be able to see dashboards for both Kafka
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/dashboard1.png)

and Zookeeper:
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/dashboard2.png)


## Demo 1 - Producing and consuming individual messages
To show a basic demo of producing and consuming individual messages you can use the commands below:

To start a producer container where we can dynamically input messages:
```
oc run kafka-producer -n myproject  -ti --image=strimzi/kafka:0.12.1-kafka-2.2.1 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic1
```

To start a consumer container so we can see the received messages:
```
oc run kafka-consumer -n myproject -ti --image=strimzi/kafka:0.12.1-kafka-2.2.1 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic1 --from-beginning
```

## Demo 2 - Producing and consuming multiple messages
We can also simulate a more real-world scenario by using a Job. Taking a look at the `job.yaml` we will note some parameters under `spec` that we can change to manipulate numbers of actors, and number of completions (each container instance serves as a "user" on our application)

In our default example we want to have three actors at a given time, 100 total completions, and provide the requests and limits for container resources to be 150/250 respectively
```
parallelism: 3
completions: 200
resources:
  requests:
    memory: "150Mi"
    cpu: "150m"
  limits:
    memory: "250Mi"
    cpu: "250m"
```

We can also manipulate the kafka-specific parameters under the `command` spec, this will allow us to send messages to other topics, increase the number of messages per actor, how large the messages are, and how quickly they come through:

In our default example we want to send our messages to the topic `my-topic1`, each actor sending 10 messages, each message with a record size of 5 bytes, and at a throughput of 1000 messages/second maximum.
```
--topic my-topic1
--num-records 10
--record-size 5
--throughput 1000
```

In order to run this demo just create the job which deploys a kafka producer writing messages to `my-topic1`
```
oc create -f job1.yaml -n myproject
```

To start a consumer for `my-topic1` messages
```
oc create -f consumer1.yaml -n myproject
```

If you want to demonstrate a second topic/producer combo running in parallel writing messages to `my-topic2`
```
oc create -f job2.yaml -n myproject
```

To start a consumer for `my-topic2` messages
```
oc create -f consumer2.yaml -n myproject
```

Navigate to the logs of a consumer to view incoming messages
```
oc logs kafka-consumer1
oc logs kafka-consumer2
```

## Bonus:
Navigate to the Openshift UI and demo through all of the dynamic changes, monitoring, resource consumption, etc.
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/openshift1.png)

If you are using Openshift 4 you can also see additional cluster level metrics for pods, for example our kafka broker `kafka-cluster-0`
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/openshift2.png)

Navigate back to the Grafana UI to see Kafka/Zookeeper specific metrics collected by Prometheus and how the Jobs that we deployed in our demo can be visualized in real-time


### Additional Useful Commands:

List all kafka topics
```
oc get kafkatopic
```

To scale your Kafka cluster up, add a broker using the commmand below and modify the `replicas:1 --> 2` for kafka brokers
```
oc edit -f kafka-cluster.yaml -n myproject
```

To edit your topic (i.e. adding topic parameters or scaling up partitions)
```
oc edit -f my-topic1.yaml
```

## Uninstall

Run
```
./uninstall-single.sh
```

### Manual Steps to Uninstall

Removing the producers:
```
oc delete pod kafka-producer1 -n myproject
oc delete pod kafka-producer2 -n myproject
```

Removing the consumers:
```
oc delete pod kafka-consumer1 -n myproject
oc delete pod kafka-consumer2 -n myproject
```

Removing Jobs:
```
oc delete -f job1.yaml -n myproject
oc delete -f job2.yaml -n myproject
oc delete -f job3.yaml -n myproject
oc delete -f job4.yaml -n myproject
```

Remove Kafka topics
```
oc delete -f my-topic1.yaml
oc delete -f my-topic2.yaml
oc delete -f my-topic3.yaml
```

Delete Kafka Cluster
```
oc delete -f kafka-cluster.yaml -n myproject
```

Delete Prometheus:
```
oc delete -f alerting-rules.yaml -n myproject
oc delete -f prometheus.yaml -n myproject
```

Delete Grafana:
```
oc delete -f grafana.yaml -n myproject
```

Remove Strimzi Operator
```
oc delete -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n myproject
```
