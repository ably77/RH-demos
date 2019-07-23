# When auth.openShiftoAuth is enabled:

NAMESPACE=workspaces

oc create clusterrole codeready-operator --resource=oauthclients --verb=get,create,delete,update,list,watch
oc create clusterrolebinding codeready-operator --clusterrole=codeready-operator --serviceaccount=${NAMESPACE}:codeready-operator

# When server.selfSignedCerts is enabled:
oc create role secret-reader --resource=secrets --verb=get -n=openshift-ingress
oc create rolebinding codeready-operator --role=secret-reader --serviceaccount=${NAMESPACE}:codeready-operator -n=openshift-ingress
