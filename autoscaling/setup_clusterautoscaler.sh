
#!/bin/bash

maxnodestotal=6
cores_min=4
cores_max=24
mem_min=4
mem_max=32
scaledown_enabled=true

sed -e "s/<MAXNODESTOTAL>/${maxnodestotal}/g" -e "s/<CORES_MIN>/${cores_min}/g" -e "s/<CORES_MAX>/${cores_max}/g" -e "s/<MEM_MIN>/${mem_min}/g" -e "s/<MEM_MAX>/${mem_max}/g" -e "s/<SCALEDOWN_ENABLED>/${scaledown_enabled}/g" clusterautoscaler.template.yaml > clusterautoscaler.yaml
