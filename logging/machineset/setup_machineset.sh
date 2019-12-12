
#!/bin/bash

clusterid=ly-demo-bdxnm
role=infra
second_role=logging
instancetype=t3.2xlarge
region=us-east-1
zone=c
ami_id=ami-01e7fdcb66157b224
desired_replicas=3


sed -e "s/<clusterID>/${clusterid}/g" -e "s/<role>/${role}/g" -e "s/<second_role>/${second_role}/g" -e "s/<INSTANCETYPE>/${instancetype}/g" -e "s/<REGION>/${region}/g" -e "s/<ZONE>/${zone}/g" -e "s/<AMIID>/${ami_id}/g" -e "s/<REPLICAS>/${desired_replicas}/g" machineset.template.yaml > $clusterid-$role-$region$zone.yaml
