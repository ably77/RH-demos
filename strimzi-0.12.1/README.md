# Strimzi Kafka Demo

## Prerequisites:
- Openshift/Kubernetes Cluster
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

### Apply Strimzi Installation File
Next we apply the Strimzi install files, including `ClusterRoles`, `ClusterRoleBindings` and some Custom Resource Definitions (`CRDs`). The CRDs define the schemas used for declarative management of the Kafka cluster, Kafka topics and users.

```
oc apply -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n myproject
```

### Provision the Apache Kafka Cluster
After that we feed Strimzi with a simple Custom Resource, which will than give you a small persistent Apache Kafka Cluster with one node for each, Apache Zookeeper and Apache Kafka:

For our demo we will be using a single kafka broker that uses ephemeral storage and exposes Prometheus metrics:
```
oc apply -f kafka-cluster.yaml
```

We can now watch the deployment on the myproject namesapce, and see all required pods being created:
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

## Monitoring using Prometheus and Grafana
First start up your Prometheus server:
```
oc create -f alerting-rules.yaml
oc create -f prometheus.yaml
```

Then start your Grafana server:
```
oc create -f grafana.yaml
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
(Insert Picture Here)

Click on the "Add data Source" icon in the Grafana Homepage
(Insert Picture Here)

Add Prometheus as a datasource, specifying the information below and select Save & Test at the bottom
```
Name: prometheus
Type: Prometheus
URL: http://prometheus:9090
```

From the top left menu, click on "Dashboards" and then "Import" to open the "Import Dashboard" window where the provided strimzi-kafka.json and strimzi-zookeeper.json files can be imported or their content pasted.
(Insert Picture Here)

Now you should be able to see dashboards for both Kafka and Zookeeper!
(Insert Picture Here)

## Create Topics
```
oc create -f my-topic1.yaml
oc create -f my-topic2.yaml
```

## Demo 1
To show a basic demo of producing and consuming individual messages you can use the commands below:

To start a producer container where we can dynamically input messages:
```
oc run kafka-producer -ti --image=strimzi/kafka:0.12.1-kafka-2.2.1 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic1
```

To start a consumer container so we can see the received messages:
```
oc run kafka-consumer -ti --image=strimzi/kafka:0.12.1-kafka-2.2.1 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic1 --from-beginning
```

## Demo 2
We can also simulate a more real-world scenario by using a Job. Taking a look at the `job.yaml` we will note some parameters under `spec` that we can change to manipulate numbers of actors, and number of completions (each container instance serves as a "user" on our application)

In our default example we want to have three actors at a given time, 100 total completions, and provide the requests and limits for container resources to be 150/250 respectively
```
parallelism: 3
completions: 100
resources:
  requests:
    memory: "150Mi"
    cpu: "150m"
  limits:
    memory: "250Mi"
    cpu: "250m"
```

We can also manipulate the kafka-specific parameters under the `command` spec, this will allow us to send messages to other topics, increase the number of messages per actor, how large the messages are, and how quickly they come through:

In our default example we want to send our messages to the topic `my-topic`, each actor sending 10 messages, each message with a record size of 5 bytes, and at a throughput of 1000 messages/second maximum.
```
--topic my-topic1
--num-records 10
--record-size 5
--throughput 1000
```

In order to run this demo just create the job which deploys a kafka producer writing messages to `my-topic1`
```
oc create -f job1.yaml
```

To start a consumer for `my-topic1` messages
```
oc create -f consumer1.yaml
```

If you want to demonstrate a second topic/producer combo running in parallel writing messages to `my-topic2`
```
oc create -f job2.yaml
```

To start a consumer for `my-topic2` messages
```
oc create -f consumer2.yaml
```

Navigate to the logs of a consumer to view incoming messages
```
oc logs kafka-consumer1
oc logs kafka-consumer2
```

Bonus:
- Navigate to the Openshift UI and demo through all of the dynamic changes, monitoring, resource consumption, etc.
  - If you are using Openshift 4 you can also see additional cluster level metrics for pods
- Navigate to the Grafana UI to see Kafka/Zookeeper specific metrics collected by Prometheus


### Additional Useful Commands:

List all kafka topics
```
oc get kafkatopic
```

To scale your Kafka cluster up, add a broker using the commmand below and modify the `replicas:1 --> 2` for kafka brokers
```
oc edit -f kafka-cluster.yaml
```

To edit your topic (i.e. adding topic parameters or scaling up partitions)
```
oc edit -f my-topic1.yaml
```

## Uninstall

Run
```
./uninstall.sh
```

### Manual Steps to Uninstall

Removing the consumers:
```
oc delete pod kafka-consumer1
oc delete pod kafka-consumer2
```

Removing Jobs:
```
oc delete -f job1.yaml
oc delete -f job2.yaml
oc delete -f job3.yaml
oc delete -f job4.yaml
```

Delete Kafka Cluster
```
oc delete -f kafka-cluster.yaml
```

Delete Prometheus:
```
oc delete -f alerting-rules.yaml
oc delete -f prometheus.yaml
```

Delete Grafana:
```
oc delete -f grafana.yaml
```

Remove Strimzi Operator
```
oc delete -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.12.1/strimzi-cluster-operator-0.12.1.yaml -n myproject
```
