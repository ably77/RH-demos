#!/bin/bash

node=$1
key=role
value=logging
# options are NoSchedule, PreferNoSchedule, or NoExecute
effect=NoSchedule

oc adm taint nodes ${node} ${key}=${value}:${effect}
