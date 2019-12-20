argo_namespace="argo"
argowf_version="2.4.3"

# Create a new namespace for ArgoCD components
oc new-project ${argo_namespace}

# grant admin privileges to the service account in the namespace
oc create rolebinding default-admin --clusterrole=admin --serviceaccount=${argo_namespace}:default --namespace=${argo_namespace}

# Apply the Argo Workflow Install Manifest
oc apply -n ${argo_namespace} -f https://raw.githubusercontent.com/argoproj/argo/v${argowf_version}/manifests/install.yaml

# use the default namespace
oc project default

# apply workflow-controller configmap due to https://github.com/argoproj/argo/issues/1272
# this allows this demo to run on openshift
oc apply -f extras/workflow-configmap.yaml

# submit hello-world workflow example
argo submit --watch https://raw.githubusercontent.com/argoproj/argo/master/examples/hello-world.yaml --insecure-skip-tls-verify --namespace ${argo_namespace}

# submit loops-maps workflow example
argo submit --watch https://raw.githubusercontent.com/argoproj/argo/master/examples/loops-maps.yaml --namespace= ${argo_namespace}

# port-forward for the argo UI
kubectl -n argo port-forward deployment/argo-ui 8001:8001

echo open http://127.0.0.1:8001 for the argo workflows UI
