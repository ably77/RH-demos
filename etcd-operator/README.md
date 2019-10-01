## Scale etcd cluster

Modify the `./etcd-operator/example/example-etcd-cluster.yaml`
```
apiVersion: "etcd.database.coreos.com/v1beta2"
kind: "EtcdCluster"
metadata:
  name: "example-etcd-cluster"
  ## Adding this annotation make this cluster managed by clusterwide operators
  ## namespaced operators ignore it
  # annotations:
  #   etcd.database.coreos.com/scope: clusterwide
spec:
  size: 5
  version: "3.2.13"
```

Update the etcd cluster by replacing the configuration:
```
oc replace -f etcd-operator/example/example-etcd-cluster.yaml
```

## Monitor the etcd cluster

Examine the etcd Operator events:
```
oc get events | grep etcdcluster
```

Examine the services in your project:
```
oc get services
```

## Delete the etcd cluster
```
oc delete etcdcluster example-etcd-cluster
```

## Cleaning up the environment
```
cd etcd-operator
oc delete -f example/deployment.yaml
oc delete clusterrole etcd-operator
oc delete clusterrolebinding etcd-operator
oc delete crd etcdclusters.etcd.database.coreos.com
```

Delete your etcd-operators project
```
oc delete project etcd-operators
```
