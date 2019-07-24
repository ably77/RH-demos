
#!/bin/bash

nodeip=$(oc get nodes | grep worker | awk 'NR==1{ print $1 }')
nodeportbs=$(oc get service my-cluster-kafka-external-bootstrap -n myproject -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}')
nodeport0=$(oc get service my-cluster-kafka-0 -n myproject -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}')
nodeport1=$(oc get service my-cluster-kafka-1 -n myproject -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}')
nodeport2=$(oc get service my-cluster-kafka-2 -n myproject -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}')

sed -e "s/<PRODUCERNAME>/kafka-producer1/g" -e "s/<KAFKATOPIC>/my-topic1/g" -e "s/<RECORDSIZE>/5/g" -e "s/<NODEIP>/${nodeip}/g" -e "s/<NODEPORTBS>/${nodeportbs}/g" -e "s/<NODEPORT0>/${nodeport0}/g" -e "s/<NODEPORT1>/${nodeport1}/g" -e "s/<NODEPORT2>/${nodeport2}/g" job.template.yaml > job1.yaml
sed -e "s/<PRODUCERNAME>/kafka-producer2/g" -e "s/<KAFKATOPIC>/my-topic2/g" -e "s/<RECORDSIZE>/5/g" -e "s/<NODEIP>/${nodeip}/g" -e "s/<NODEPORTBS>/${nodeportbs}/g" -e "s/<NODEPORT0>/${nodeport0}/g" -e "s/<NODEPORT1>/${nodeport1}/g" -e "s/<NODEPORT2>/${nodeport2}/g" job.template.yaml > job2.yaml
sed -e "s/<PRODUCERNAME>/kafka-producer3/g" -e "s/<KAFKATOPIC>/my-topic1/g" -e "s/<RECORDSIZE>/10/g" -e "s/<NODEIP>/${nodeip}/g" -e "s/<NODEPORTBS>/${nodeportbs}/g" -e "s/<NODEPORT0>/${nodeport0}/g" -e "s/<NODEPORT1>/${nodeport1}/g" -e "s/<NODEPORT2>/${nodeport2}/g" job.template.yaml > job3.yaml
