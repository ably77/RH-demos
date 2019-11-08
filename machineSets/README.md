# Machine Sets

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

# Creating a New Machine Set
Use the script called `setup_machineset.sh` in order to create a new machine set based off of the `machineset.template.yaml`. Using a text editor of choice, edit the file and replace the variable values to desired values. See example below

## Set worker_node variable
```
worker_node=ly-demo-jv56h-worker-us-east-1a
```

## grep for clusterID
```
oc get machineset -n openshift-machine-api $worker_node -o yaml | grep machine.openshift.io/cluster-api-cluster:
```

## grep for AMI ID value
```
oc get machineset -n openshift-machine-api $worker_node -o yaml | grep ami
```

## Modify values in setup_infra_machineset.sh
```
clusterid=ly-demo-jv56h
role=infra
instancetype=t3.large
region=us-east-1
zone=b
ami_id=ami-01e7fdcb66157b224
desired_replicas=1
```

## Run the script to create your new MachineSet yaml
```
./setup_machineset.sh
```

## Deploy the MachineSet
```
oc create -f <machineset_name.yaml>
```

## Validate MachineSet output for state
```
oc get machinesets -n openshift-machine-api
```

You can see that if the number of desired replicas is greater than the current that the MachineSet will initiate the creation of a new infrastructure resource. Navigate to the AWS Console to see the resources being created dynamically by Openshift
(Insert Picture Here)

## View the new node and confirm that the new node has the label that you specified
```
oc get node <node_name> --show-labels
```

Example output below:
```
$ oc get node ip-10-0-187-57.us-west-2.compute.internal --show-labels
NAME                                        STATUS    ROLES     AGE       VERSION             LABELS
ip-10-0-187-57.us-west-2.compute.internal   Ready     worker    2m        v1.14.0+011679b8e   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=m5.large,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=us-west-2,failure-domain.beta.kubernetes.io/zone=us-west-2d,kubernetes.io/arch=amd64,kubernetes.io/hostname=ip-10-0-187-57,kubernetes.io/os=linux,node-role.kubernetes.io/worker=,node.openshift.io/os_id=rhcos
```
