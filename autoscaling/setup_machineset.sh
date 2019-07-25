
#!/bin/bash

clusterid=ly-cluster-wcqcb
role=worker
region=us-west-2
zone=a
ami_id=12345
desired_replicas=2


sed -e "s/<CLUSTERID>/${clusterid}/g" -e "s/<ROLE>/${role}/g" -e "s/<REGION>/${region}/g" -e "s/<ZONE>/${zone}/g" -e "s/<AMIID>/${ami_id}/g" -e "s/<REPLICAS>/${desired_replicas}/g" machineset.template.yaml > $clusterid-$role-$region$zone.yaml
