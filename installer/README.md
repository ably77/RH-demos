# Installing an Openshift 4 Cluster using AWS

## Prerequisites
- AWS Account Access with admin privileges
- SSH keypair
- AWS IAM access key and secret access key credentials

## Installing

To run the default install
```
./bin/openshift-install create cluster --dir=<installation_directory> --log-level debug
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

## Uninstalling Openshift 4

To uninstall the Openshift 4 cluster
```
./bin/openshift-install destroy cluster --dir=<installation_directory> --log-level debug
```

Optional: Delete the <installation_directory> directory and the OpenShift Container Platform installation program.
