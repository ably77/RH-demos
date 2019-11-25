namespace=default

kubectl delete pods -n ${namespace} --field-selector=status.phase!=Running
