# CodeReady Operator Demo

## Prerequisites
- Running Openshift Cluster
- User with cluster-admin privileges
- kubectl or oc-cli authenticated to the cluster

### Using the CLI

On an authenticated cluster with a user that has cluster-admin privileges, run the command below to start the CodeReady Workspaces Operator:
```
./codeready-workspaces-operator-installer/deploy.sh --deploy
```

### Uninstalling

#### Removing existing Workspaces

In the CodeReady Workspaces GUI, navigate to the Workspaces tab to remove existing workspaces. Note that existing workspaces and data persists even if you remove the CodeReady Workspaces Operator

If you have already uninstalled the Operator, you can manually clean up any existing resources by running the commands below
```
oc get deployments

oc delete deployment <workspace-ID>

oc get routes

oc delete routes <workspace-route-ID>
```

#### Uninstalling the CodeReady Workspaces Operator
To uninstall the CodeReady Workspaces Operator you can delete the custom resource, which deletes all of the associated objects
```
oc delete checluster/codeready -n $targetNamespace
```

Here, $targetNamespace is an OpenShift project with deployed CodeReady Workspaces (workspaces is the OpenShift project by default).
