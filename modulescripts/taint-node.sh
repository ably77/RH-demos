#!/bin/bash

node=$1
key=key1
value=value1
# options are NoSchedule, PreferNoSchedule, or NoExecute
effect=NoSchedule

oc adm taint nodes ${node} ${key}=${value}:${effect}
