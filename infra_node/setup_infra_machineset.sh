
#!/bin/bash

clusterid=ly-demo-jv56h
role=infra
instancetype=t3.xlarge
region=us-east-1
zone=c
ami_id=ami-01e7fdcb66157b224
desired_replicas=2


sed -e "s/<clusterID>/${clusterid}/g" -e "s/<role>/${role}/g" -e "s/<INSTANCETYPE>/${instancetype}/g" -e "s/<REGION>/${region}/g" -e "s/<ZONE>/${zone}/g" -e "s/<AMIID>/${ami_id}/g" -e "s/<REPLICAS>/${desired_replicas}/g" infra.machineset.template.yaml > $clusterid-$role-$region$zone.yaml
