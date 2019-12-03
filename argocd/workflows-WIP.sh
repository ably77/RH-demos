argowf_namespace="argo"
argowf_version="2.4.2"

# Create a new namespace for ArgoCD components
oc new-project ${argowf_namespace}

# Apply the Argo Workflow Install Manifest
kubectl apply -n ${argowf_namespace} -f https://raw.githubusercontent.com/argoproj/argo/v${argowf_version}/manifests/install.yaml

# make sure you are on the default namespace before running grant permissions below
oc project default

# grant admin privileges to the service account in the namespace
oc create rolebinding default-admin --clusterrole=admin --serviceaccount=default:default

# submit workflow
argo submit --watch https://raw.githubusercontent.com/argoproj/argo/master/examples/hello-world.yaml --serviceaccount argocd
