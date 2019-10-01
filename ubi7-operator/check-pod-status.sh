#!/bin/bash

seconds=0
OUTPUT=0
pod_name=$1
namespace=$2
hashed_name=$(oc get pods -n ${namespace} | grep ${pod_name}  | awk 'NR==1{ print $1 }')


sleep 5

while [ "$OUTPUT" -ne 1 ]; do
  OUTPUT=`oc get pods ${hashed_name} -n ${namespace} | tail -n +2 | grep -c Running`;
  seconds=$((seconds+5))
  printf "Waiting %s seconds for ${pod_name} to come up.\n" "${seconds}"
  sleep 5
done

echo $pod_name is up and Running!
