# Openshift Strimzi Kafka Operator Demo - Multi-node Deployment (AWS)

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
- Multi Node Openshift/Kubernetes Cluster (3 workers minimum)
- Admin Privileges (i.e. cluster-admin RBAC privileges or logged in as system:admin user)

## Running this Demo
If you have an Openshift cluster up and are authenticated to the CLI, just run the command below. If you prefer to run through the commands manually, the instructions are in the section below.
```
./runme-3broker.sh
```

This quick script will:
- Login to Openshift as an admin
- Deploy the Strimzi Kafka Operator
- Deploy an ephemeral kafka cluster with 3 broker nodes and 3 zookeeper nodes
- Create three Kafka topics (my-topic1, my-topic2, my-topic3)
- Deploy Prometheus
- Deploy Grafana
- Forward port 3000 to localhost for Grafana

Once complete, open Grafana and login as `admin/admin`
```
open http://localhost:3000
```
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

Paste/import the contents of `dashboards/kafka-dashboard.json` located in the Dashboards directory this repo
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana6.png)

Select Prometheus in the drop-down as your data-source
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana7.png)

Now, repeat these steps for importing the Zookeeper dashboard

Once you're done you should be able to see dashboards for both Kafka
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/dashboard1.png)

and Zookeeper:
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/dashboard2.png)

## Accessing Kafka

REF: https://strimzi.io/2019/04/17/accessing-kafka-part-1.html

In a single-node deployment of Kafka, routing and accessing the brokers is easy because everything is running on the same node. When we move to multi-node deployments, accessing the Kafka cluster requires additional Services to be created in order to route the traffic correctly. Read the reference link above to have a deeper understanding of Kafka's discovery protocol and more on the routing options below
- Using NodePorts
- Using OpenShift routes
- Using Load Balancers
- Using Ingress

### Node Ports
REF: https://strimzi.io/2019/04/23/accessing-kafka-part-2.html

A NodePort is a special type of Kubernetes service. When such a service is created, Kubernetes will allocate a port on all nodes of the Kubernetes cluster and will make sure that all traffic to this port is routed to the service and eventually to the pods behind this service.

The routing of the traffic is done by the kube-proxy Kubernetes component. It doesn’t matter which node your pod is running on. The node ports will be open on all nodes and the traffic will always reach your pod. So your clients need to connect to the node port on any of the nodes of the Kubernetes cluster and let Kubernetes handle the rest.

The node port is selected from the port range 30000-32767 by default. But this range can be changed in Kubernetes configuration (see Kubernetes docs for more details about configuring the node port range).

#### Setting up NodePort routes

Take a look at your existing services, note that some components are exposed using type NodePort
```
oc get services -n myproject
```

The script below will use the parameterized `job.template.yaml` and set up three files in your directory named `job1.yaml`, `job2.yaml`, and `job3.yaml` that are configured correctly to use the NodePort services to route to the Kafka cluster brokers
```
./setup-jobs.sh
```

If you open up the newly created files such as `job1.yaml` you will see the route populated with the correct hostname:nodePort, example below:
```
bootstrap.servers=ip-10-0-135-104.us-west-2.compute.internal:31316,ip-10-0-135-104.us-west-2.compute.internal:32283,ip-10-0-135-104.us-west-2.compute.internal:31803,ip-10-0-135-104.us-west-2.compute.internal:32289
```

## Demo 1 - Producing and consuming individual messages
To show a basic demo of producing and consuming individual messages you can use the commands below:

To start a producer container where we can dynamically input messages
```
./producer1.sh
```

To start a consumer container so we can see the received messages
```
./consumer1.sh
```

## Demo 2 - Producing and consuming multiple messages
We can also simulate a more real-world scenario by using a Job. Taking a look at the `job.template.yaml` we will note some parameters under `spec` that we can change to manipulate numbers of actors, and number of completions (each container instance serves as a "user" on our application)

In our default example we want to have three actors at a given time, 200 total completions, and provide the requests and limits for container resources to be 150/250 respectively
```
parallelism: 3
completions: 50
resources:
  requests:
    memory: "150Mi"
    cpu: "150m"
  limits:
    memory: "250Mi"
    cpu: "250m"
```

We can also manipulate the kafka-specific parameters under the `command` spec, this will allow us to send messages to other topics, increase the number of messages per actor, how large the messages are, and how quickly they come through:

In our default example we want to send our messages to the topic `my-topic1`, each actor sending 100000 messages, each message with a record size of 5 bytes, and at a throughput of 1M messages/second maximum.
```
--topic my-topic1
--num-records 100000
--record-size 5
--throughput 1000000
```

### Create your job files
A producer has been templatized into the example `job.template.yaml` file from which we will generate `job1.yaml`, `job2.yaml`, and `job3.yaml`
```
./setup-jobs.sh
```

Running this script will grab and set the correct variables for `<NODEIP>`,`<nodePort>` because these parameters will be different per each deployment

### Running the Demo

Deploy the `job1.yaml` which deploys a kafka producer writing messages to `my-topic1`
```
oc create -f job1.yaml -n myproject
```

To start a consumer for `my-topic1` messages
```
./consumer1.sh
```

If you want to demonstrate a second topic/producer combo running in parallel writing messages to `my-topic2`
```
oc create -f job2.yaml -n myproject
```

To start a consumer for `my-topic2` messages
```
./consumer2.sh
```

Navigate to the logs of a consumer to view incoming messages
```
oc logs kafka-consumer1 -n myproject
oc logs kafka-consumer2 -n myproject
```

A single kafka topic can also handle many Producers sending many different messages to it, to demonstrate this you can run `job3.yaml`
```
oc create -f job3.yaml -n myproject
```

Taking a look at the `job3.yaml` compared to `job1.yaml` you can see that the only difference is in record-size
```
--record-size 10
```

Navigate back to the logs of `kafka-consumer1` and you should see two streams of different record sizes being consumed on `my-topic1`. An example output is below
```
$ oc logs kafka-consumer1 -n myproject
SSXVN
SSXVN
SSXVN
SSXVN
SSXVN
SSXVNJHPDQ
SSXVNJHPDQ
SSXVNJHPDQ
SSXVNJHPDQ
```

## Bonus:
Navigate to the Openshift UI and demo through all of the orchestration of pods, jobs, monitoring, resource consumption, etc.
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/openshift1.png)

If you are using Openshift 4 you can also see additional cluster level metrics for pods, for example our kafka broker `kafka-cluster-0`
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/openshift2.png)

Navigate back to the Grafana UI to see Kafka/Zookeeper specific metrics collected by Prometheus and how the Jobs that we deployed in our demo can be visualized in real-time
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/openshift3.png)


### Additional Useful Commands:

List all kafka topics
```
oc get kafkatopic
```

To scale your Kafka cluster up, add a broker using the commmand below and modify the `replicas:1 --> 2` for kafka brokers
```
oc edit -f yaml/kafka-cluster-3broker.yaml -n myproject
```

To edit your topic (i.e. adding topic parameters or scaling up partitions)
```
oc edit -f yaml/my-topic1.yaml
```

## Uninstall

Run
```
./uninstall.sh
```

### Manual Steps to Uninstall

Removing the consumers:
```
oc delete pod kafka-consumer1 -n myproject
oc delete pod kafka-consumer2 -n myproject
```

Removing Jobs:
```
oc delete -f yaml/job1.yaml -n myproject
oc delete -f yaml/job2.yaml -n myproject
oc delete -f yaml/job3.yaml -n myproject
```

Remove Kafka topics
```
oc delete -f yaml/my-topic1.yaml
oc delete -f yaml/my-topic2.yaml
oc delete -f yaml/my-topic3.yaml
```

Delete Kafka Cluster
```
oc delete -f yaml/kafka-cluster-3broker.yaml -n myproject
```

Delete Prometheus:
```
oc delete -f yaml/alerting-rules.yaml -n myproject
oc delete -f yaml/prometheus.yaml -n myproject
```

Delete Grafana:
```
oc delete -f yaml/grafana.yaml -n myproject
```

Remove Strimzi Operator
```
oc delete -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n myproject
```
