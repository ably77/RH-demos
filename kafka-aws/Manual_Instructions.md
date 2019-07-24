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
oc apply -f kafka-cluster-3broker.yaml -n myproject
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
oc create -f my-topic3.yaml
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
oc port-forward -n myproject <grafana-6b59f9886c-7sccm> 3000:3000
```

Open Grafana and login as `admin/admin`
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

Paste/import the contents of `kafka-dashboard.json` located in the Dashboards directory this repo
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana6.png)

Select Prometheus in the drop-down as your data-source
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/grafana7.png)

Now, repeat these steps for importing the Zookeeper dashboard

Once you're done you should be able to see dashboards for both Kafka
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/dashboard1.png)

and Zookeeper:
![](https://github.com/ably77/RH-demos/blob/master/strimzi-0.12.1/resources/dashboard2.png)
