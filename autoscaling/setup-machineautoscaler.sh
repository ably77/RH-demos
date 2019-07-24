
#!/bin/bash

machinesetid=ly-cluster-wcqcb-worker-us-west-2a

sed -e "s/<MACHINESETID>/${machinesetid}/g" machineautoscaler.template.yaml > $machinesetid.yaml
