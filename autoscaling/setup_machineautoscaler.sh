
#!/bin/bash

machinesetid=ly-cluster-wcqcb-worker-us-west-2a
minreplicas=1
maxreplicas=6

sed -e "s/<MACHINESETID>/${machinesetid}/g" -e "s/<MINREPLICAS>/${minreplicas}/g" -e "s/<MAXREPLICAS>/${maxreplicas}/g" machineautoscaler.template.yaml > $machinesetid.yaml
