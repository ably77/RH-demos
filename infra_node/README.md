# Show existing MachineSets
```
oc get machineset -n openshift-machine-api
```

# Set worker_node variable
```
worker_node=ly-demo-jv56h-worker-us-east-1a
```

# Take a look at an existing MachineSet
```
oc get machineset -n openshift-machine-api $worker_node -o yaml
```

# grep for clusterID
```
oc get machineset -n openshift-machine-api $worker_node -o yaml | grep machine.openshift.io/cluster-api-cluster:
```

# grep for AMI ID value
```
oc get machineset -n openshift-machine-api $worker_node -o yaml | grep ami
```

# Modify values in setup_infra_machineset.sh
```
clusterid=ly-demo-jv56h
role=infra
instancetype=t3.large
region=us-east-1
zone=b
ami_id=ami-01e7fdcb66157b224
desired_replicas=1
```

# Run script
```
./setup_infra_mashineset.sh
```

# Deploy Infra Node
```
oc create -f <infra node>.yaml
```
