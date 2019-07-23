# Installing an Openshift 4 Cluster using AWS

## Prerequisites
- AWS Account Access with admin privileges
- SSH keypair
- AWS IAM access key and secret access key credentials

## Installing

To run the default install
```
./openshift-install create cluster --dir=<installation_directory> --log-level debug
```

To create a custom install config
```
./bin/openshift-install create install-config --dir=<installation_directory>
```

Modify the custom install config (for example change masters to 1 from 3)
```
controlPlane:
  hyperthreading: Enabled
  name: master
  platform: {}
  replicas: 1
```

To install using custom config
```
./bin/openshift-install create cluster --dir=<installation_directory> --log-level debug
```

## Machine Sets

View current machine sets
```
oc get machinesets -n openshift-machine-api
```

Check values of a specific MachineSet
```
oc get machineset <machineset_name> -n openshift-machine-api -o yaml
```

Creating a Machine Set

Modify the `machineset.template.yaml` to replace `<clusterID>`, `<role>`, and `<region>` parameter values. In this sample, <clusterID> is the cluster ID that you set when you provisioned the cluster and <role> is the node label to add.

Common Region Options:
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

View the new node and confirm that the new node has the label that you specified
```
oc get node <node_name> --show-labels
```

## Uninstalling

To uninstall the Openshift 4 cluster
```
./bin/openshift-install destroy cluster --dir=<installation_directory> --log-level debug
```

Optional: Delete the <installation_directory> directory and the OpenShift Container Platform installation program.
