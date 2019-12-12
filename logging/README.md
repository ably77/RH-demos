# Setting Up EFK Logging

### Sizing Recommendations
It is recommended to run the Elasticsearch nodes with a minimum of 16GB MEM in production. For this reason we will be using the AWS t3.2xlarge instance type in this demonstration (8vCPU / 32GB MEM)

### Set up Infra/Logging machineset (optional but recommended)

Change to machineset directory
```
cd machineset
```

grep for clusterID
```
oc get machineset -n openshift-machine-api $worker_node -o yaml | grep machine.openshift.io/cluster-api-cluster:
```

grep for AMI ID value
```
oc get machineset -n openshift-machine-api $worker_node -o yaml | grep ami
```

Edit machineset variables
```
vi setup_machineset.sh
```

Parameters to change:
```
clusterid=ly-demo-bdxnm
role=infra
second_role=logging
instancetype=t3.xlarge
region=us-east-1
zone=c
ami_id=ami-01e7fdcb66157b224
desired_replicas=3
```

Create the Infra/Logging node manifest
```
./setup_machineset.sh
```

Create machineset:
```
oc create -f <machineset_name>.yaml
```

View machineset status:
```
oc get machineset -n openshift-machine-api
```

### Setting up node taints (optional but recommended)
While it is possible to run the EFK deployment in conjunction with other workloads on the infra node, it is not the recommended best practice. The steps below outline how to add a taint to the logging nodes so that only pods with the correct toleration can be deployed onto these nodes. To set up taints for our logging nodes follow the instructions below

Get a list nodes
```
$ oc get nodes
NAME                           STATUS   ROLES                  AGE     VERSION
ip-10-0-130-128.ec2.internal   Ready    worker                 4h26m   v1.14.6+c07e432da
ip-10-0-133-105.ec2.internal   Ready    master                 4h33m   v1.14.6+c07e432da
ip-10-0-149-157.ec2.internal   Ready    infra,logging,worker   23m     v1.14.6+c07e432da
ip-10-0-150-44.ec2.internal    Ready    infra,logging,worker   23m     v1.14.6+c07e432da
ip-10-0-155-196.ec2.internal   Ready    worker                 4h26m   v1.14.6+c07e432da
ip-10-0-157-83.ec2.internal    Ready    infra,logging,worker   23m     v1.14.6+c07e432da
ip-10-0-208-237.ec2.internal   Ready    worker                 4h26m   v1.14.6+c07e432da
```

Taint only the nodes with the logging role
```
./logging-taint <NODE_NAME>
```

View your taint
```
$ oc describe node ip-10-0-149-157.ec2.internal
Name:               ip-10-0-149-157.ec2.internal
Roles:              infra,logging,worker
<...>
Taints:             role=logging:NoSchedule
<...>
```

### Explore CR tolerations
In the `openshift_logging_cr.yaml` located in this repo you can see the tolerations in the manifest that will match the `role=logging:NoSchedule` taint

```
tolerations:
- key: "role"
  operator: "Equal"
  value: "logging"
  effect: "NoSchedule"
```

Note: If you do not set up the node taints, the EFK deployment will not work properly unless you comment out the tolerations sections

## Once the Infra/Logging nodes are up and running

Follow the instructions in the Logging_OCP4.pdf to complete EFK logging deployment. You can modify and use the openshift_logging_cr.yaml that is included in this repo once you have set up the ElasticSearch and Cluster Logging Operators from OperatorHub

List pods:
```
$ oc get pods -n openshift-logging
NAME                                            READY   STATUS    RESTARTS   AGE
cluster-logging-operator-5cc64b88b5-k5hv5       1/1     Running   0          16m
elasticsearch-cdm-48zgx6fb-1-5995686454-xdkg4   2/2     Running   0          14m
elasticsearch-cdm-48zgx6fb-2-7cd6c44b87-r8dxd   2/2     Running   0          13m
elasticsearch-cdm-48zgx6fb-3-64466bc6cb-ntmhv   2/2     Running   0          12m
fluentd-4567g                                   1/1     Running   0          14m
fluentd-59nkl                                   1/1     Running   0          14m
fluentd-5zxxn                                   1/1     Running   0          14m
fluentd-92kmz                                   1/1     Running   0          14m
fluentd-ffwzm                                   1/1     Running   0          14m
fluentd-k9pjs                                   1/1     Running   0          14m
fluentd-z7kpb                                   1/1     Running   0          14m
kibana-75c46c5b6-2q2tb                          2/2     Running   0          14m
```

## Opening Kibana in Browser
```
$ oc get routes
NAME     HOST/PORT                                                PATH   SERVICES   PORT    TERMINATION          WILDCARD
kibana   kibana-openshift-logging.apps.ly-demo.openshiftaws.com          kibana     <all>   reencrypt/Redirect   None
```
