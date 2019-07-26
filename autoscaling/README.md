## Machine Sets

MachineSets are used to natively create infrastructure resources through a Kubernetes using the MachineSets Operator. Built into Openshift, now an operator with the correct privileges can leverage MachineSets to create defined sets of infrastructure (i.e. instance type, availability zone, custom label) and dynamically scale up/down this resource using `ReplicaSets`

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
Use the script called `setup_machineset.sh` in order to create a new machine set based off of the `machineset.template.yaml`. Using a text editor of choice, edit the file and replace the variable values to desired values. See example below

In this sample, <clusterID> is the cluster ID that you set when you provisioned the cluster and <role> is the node label to add. See Example below
```
clusterid=ly-cluster-wcqcb
role=worker
region=us-west-2
zone=a
ami_id=12345
desired_replicas=2
```

Once complete, run the script to create your new MachineSet
```
./setup_machineset.sh
```

To create the MachineSet
```
oc create -f <machineset_name.yaml>
```

Check MachineSet output for state
```
oc get machinesets -n openshift-machine-api
```

You can see that if the number of desired replicas is greater than the current that the MachineSet will initiate the creation of a new infrastructure resource. Navigate to the AWS Console to see the resources being created dynamically by Openshift
(Insert Picture Here)

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

Once your MachineSets have been created it is possible to set up Cluster AutoScaling using the Cluster Autoscaler Operator. Since the Cluster AutoScaler operates cluster-wide, it defines a global setting for the min/max cores, memory, and nodes for the entire cluster.

### Deploy the ClusterAutoscaler
Use the script called `setup_clusterautoscaler.sh` in order to create a new cluster autoscaler based off of the `clusterautoscaler.template.yaml`. The default values are set for this demo to the parameters below, but you can change any values as you see fit.
```
maxnodestotal=15
cores_min=6
cores_max=30
mem_min=24
mem_max=120
scaledown_enabled=true
```

Generate the clusterAutoscaler.yaml file with this script
```
./setup_clusterautoscaler.sh
```

Deploy the clusterautoscaler.yaml that was created
```
oc create -f clusterautoscaler.yaml
```

### Configure MachineAutoscaler
The MachineAutoscaler resource additionally allows more granular control of how kubernetes autoscales specific MachineSets. This allows us to set more specific min/max replicas for specific MachineSet groups. For example, I want resources to scale more in zone A because my limit of EC2 instances in zone A is 20, whereas in Zone B it is only 10. A MachineAutoscaler resource needs to be created for each MachineSet in your cluster that you want to autoscale

Run the script to create your new MachineSets. The script below is templated and will generate 4 machineAutoscalers (typically zone a,b,c,d)
```
./setup_machineautoscaler.sh
```

To create the MachineSet
```
oc create -f <machineautoscaler_name.yaml>
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
