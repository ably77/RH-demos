# Setting Up EFK Logging

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

## Once the Infra/Logging nodes are up and running

Follow the instructions in the Logging_OCP4.pdf to complete EFK logging deployment. You can modify and use the openshift_logging_cr.yaml that is included in this repo once you have set up the ElasticSearch and Cluster Logging Operators from OperatorHub
