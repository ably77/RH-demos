# CodeReady Workspaces Demo

## Prerequisites
- Running Openshift Cluster
- User with cluster-admin privileges
- kubectl or oc-cli authenticated to the cluster

### Using the CLI

Because the default deployment defaults to `Self-signed-certs: True`, run the script below to set the correct permissions for Service Accounts
```
./oauth-certs-enable.sh
```

On an authenticated cluster with a user that has cluster-admin privileges, run the command below to deploy the CodeReady Workspaces Operator and Eclipse Che Cluster
```
./codeready-workspaces-operator-installer/deploy.sh --deploy
```

The script should deploy the CodeReady Workspaces Operator and all related dependencies, output should look similar to below
```
$ ./codeready-workspaces-operator-installer/deploy.sh --deploy
[INFO]: Welcome to CodeReady Workspaces Installer
[INFO]: Found oc client in PATH
[INFO]: Checking if you are currently logged in...
[INFO]: Active session found. Your current context is: workspaces/api-testing-cluster-openshiftaws-com:6443/kube:admin
[INFO]: Creating operator service account
[INFO]: Service account already exists
[INFO]: Create service account roles
[INFO]: Role Binding already exists
[INFO]: Self-signed certificate support enabled
[INFO]: Adding extra privileges for an operator service account
[INFO]: Creating secret-reader role and rolebinding in namespace openshift-ingress
[INFO]: Role secret-reader already exists
[INFO]: Creating role binding to let operator get secrets in namespace openshift-ingress
[INFO]: Role binding codeready-operator already exists in namespace openshift-ingress
[INFO]: Creating custom resource definition
[INFO]: Creating Operator Deployment
[INFO]: Existing operator deployment found. It will be deleted
[INFO]: Waiting for the deployment/codeready-operator to be scaled to 1. Timeout 300 seconds
[INFO]: Codeready Workspaces deployment/codeready-operator started in 12 seconds
[INFO]: Creating Custom resource. This will initiate CodeReady Workspaces deployment
[INFO]: CodeReady is going to be deployed with the following settings:
[INFO]: TLS support:       false
[INFO]: OpenShift oAuth:   false
[INFO]: Self-signed certs: true
[INFO]: Waiting for CodeReady Workspaces to boot. Timeout: 1200 seconds
[INFO]: CodeReady Workspaces successfully deployed and is available at http://codeready-workspaces.apps.testing-cluster.openshiftaws.com
```

### Using the GUI

Follow the instructions on the Official Red Hat Code Ready Workspaces documentation for a detailed walkthrough of deploying the CodeReady Workspaces Operator and Eclipse Che Cluster through the GUI

https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/1.2/html/administration_guide/installing-codeready-workspaces-from-operator-hub


### Creating a CodeReady Workspace

To access the CodeReady Workspace first you need to register as a new user
![](https://github.com/ably77/RH-demos/blob/master/codeready/resources/workspaces1.png)

Once logged in you create a new workspace and start by selecting your stack and memory
![](https://github.com/ably77/RH-demos/blob/master/codeready/resources/workspaces2.png)

Next add or import a project, select one of the sample projects if you don't have one already
![](https://github.com/ably77/RH-demos/blob/master/codeready/resources/workspaces3.png)

Click Create and Open when finished

Note: Allow a few minutes for your workspace to initialize and deploy

### Managing CodeReady Workspaces

Navigate to the Workspaces tab - here you can handle administrative tasks such as adding workspaces, viewing a workspace config, or stopping/starting running workspaces
![](https://github.com/ably77/RH-demos/blob/master/codeready/resources/workspaces4.png)

#### Stopping/Starting CodeReady Workspaces
Once done with their workspace, an end-user can return existing resources to the cluster by stopping their workspace. Workspaces are backed by a persistentVolume, so data will be persisted when the workspace is brought back.

Using the CLI you can see that when a workspace is removed through the console, the workspace containers are immediately terminated and resources returned to the cluster.
![](https://github.com/ably77/RH-demos/blob/master/codeready/resources/workspaces5.png)

```
$ oc get pods -w | grep workspace
workspace6zu51oje9zg747vi.dockerimage-f548d64bc-h4c7w    1/1       Running   0          2m
workspaceu5xg8zvwy79n2ewd.dockerimage-7cc4c6d8b6-jq87c   1/1       Running   0          18m
workspace6zu51oje9zg747vi.dockerimage-f548d64bc-h4c7w    1/1       Terminating   0       2m
```

Resuming the workspace will quickly initiate a new workspace container deployment, with data persisted
![](https://github.com/ably77/RH-demos/blob/master/codeready/resources/workspaces6.png)


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

#### Uninstalling the CodeReady Workspace
To uninstall the CodeReady Workspace you can delete the custom resource, which deletes all of the associated objects
```
oc delete checluster/codeready -n $targetNamespace
```

Here, $targetNamespace is an OpenShift project with deployed CodeReady Workspaces (workspaces is the OpenShift project by default).

#### Uninstalling the CodeReady Workspace Operator
```
oc delete deployment codeready-operator -n $targetNamespace
```
