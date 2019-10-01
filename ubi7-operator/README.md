# openshift-ubi7-operator

## Prerequisites
- User with Cluster Admin privileges

## Modify ansible playbooks
Once completed with modifying any /roles/ubi7/tasks move on to building your operator

## Building your Operator image

First build locally:
```
user=<quay_username>
operator-sdk build quay.io/${user}/ubi7-operator:v0.01
```

Push to quay.io:
```
docker push quay.io/${user}/ubi7-operator:v0.01
```

Modify your deploy/operator.yaml to match your Operator image:tag
```
<...>
spec:
      serviceAccountName: ubi7-operator
      containers:
        - name: ubi7-operator
          # Replace this with the built image name
          image: quay.io/<USER_NAME>/openshift-ubi7-operator:v0.01
          imagePullPolicy: Always
<...>
```

## Install the Operator
```
./runme.sh
```

## Watch your Installation
```
oc get pods -w
```

## Operator Functions

To manipulate your CR
```
oc edit ubi7

or

oc edit -f deploy/crds/ubi7-cr1.yaml
```

### Variables to Manipulate
```
size: # of ubi7 replicas in the deployment
state: present/absent
# Storage
claim: Name of persistentVolume claim
# Networking
port: port that get exposed by the container
targetport: the actual port on which your application is running inside the container
```

## Uninstalling
```
./uninstall.sh
```
