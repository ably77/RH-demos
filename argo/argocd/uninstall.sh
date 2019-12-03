argo_namespace="argo"
argowf_version="2.4.2"

# Remove the Argo Workflow Install Manifest
oc delete -n ${argo_namespace} -f https://raw.githubusercontent.com/argoproj/argo/v${argowf_version}/manifests/install.yaml

# delete admin privileges to the service account in the namespace
oc delete rolebinding default-admin --clusterrole=admin --serviceaccount=default:default
