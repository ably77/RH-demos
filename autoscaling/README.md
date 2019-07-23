## Machine Sets

View current machine sets
```
oc get machinesets -n openshift-machine-api
```

View the YAML of a specific MachineSet
```
oc get machineset <machineset_name> -n openshift-machine-api -o yaml
```

Note: it is useful to use this in order to retrieve the AMI ID or any specific labels of a desired machine in your cluster

Edit an existing MachineSet
```
oc edit machineset <machineset_name> -n openshift-machine-api
```

### Creating a New Machine Set

Modify the `machineset.template.yaml` to replace `<clusterID>`, `<role>`, `<region>`, and `<amiID>` parameter values. In this sample, <clusterID> is the cluster ID that you set when you provisioned the cluster and <role> is the node label to add.

Example AWS Region Options:
```
us-west-2a
us-west-2b
us-west-2c

us-east-1a
us-east-1b
us-east-1c
```

To create the MachineSet
```
oc create -f <machineset_name.yaml>
```

Check MachineSet output for state
```
oc get machinesets -n openshift-machine-api
```

View the new node and confirm that the new node has the label that you specified
```
oc get node <node_name> --show-labels
```

Example output below:
```
$ oc get node ip-10-0-187-57.us-west-2.compute.internal --show-labels
NAME                                        STATUS    ROLES     AGE       VERSION             LABELS
ip-10-0-187-57.us-west-2.compute.internal   Ready     worker    2m        v1.14.0+011679b8e   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=m5.large,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=us-west-2,failure-domain.beta.kubernetes.io/zone=us-west-2d,kubernetes.io/arch=amd64,kubernetes.io/hostname=ip-10-0-187-57,kubernetes.io/os=linux,node-role.kubernetes.io/worker=,node.openshift.io/os_id=rhcos
```

## Applying Autoscaling
REF: https://docs.openshift.com/container-platform/4.1/machine_management/applying-autoscaling.html

### Deploy the ClusterAutoscaler
Modify the `clusterautoscaler.yaml` file to match your desired autoscaling parameters. Deploy the ClusterAutoscaler
```
oc create -f clusterautoscaler.yaml
```

### Configure MachineAutoscaler
The MachineAutoscaler resource allows granular control of how kubernetes autoscales specific MachineSets. This allows us to set more specific min/max replicas for specific instance types. A MachineAutoscaler resource needs to be created for each MachineSet in your cluster that you want to autoscale

Modify the `machineset.template.yaml` to replace your scaling `minReplicas` and `maxReplicas` parameters and replace `<clusterID>-<role>-<region>`
```
oc create -f <machineautoscaler-machineset.yaml>
```

To view existing MachineAutoscalers
```
oc get machineautoscalers -n openshift-machine-api
```

Example output below:
```
$ oc get machineautoscalers -n openshift-machine-api
NAME                                      REF KIND     REF NAME                                  MIN       MAX       AGE
testing-cluster-5zdxx-worker-us-west-2a   MachineSet   testing-cluster-5zdxx-worker-us-west-2a   2         6         18s
testing-cluster-5zdxx-worker-us-west-2b   MachineSet   testing-cluster-5zdxx-worker-us-west-2b   1         4         45s
testing-cluster-5zdxx-worker-us-west-2c   MachineSet   testing-cluster-5zdxx-worker-us-west-2c   1         2         60s
```
