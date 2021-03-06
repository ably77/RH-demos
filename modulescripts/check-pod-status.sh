#!/bin/bash

seconds=0
OUTPUT=0
pod_name=$1
namespace=$2

sleep 5
while [ "$OUTPUT" -ne 1 ]; do
  hashed_name=$(oc get pods -n ${namespace} | grep ${pod_name}  | awk 'NR==1{ print $1 }')
  OUTPUT=`oc get pods ${hashed_name} -n ${namespace} | tail -n +2 | grep -c Running`;
  seconds=$((seconds+5))
  printf "Waiting %s seconds for ${pod_name} to come up.\n" "${seconds}"
  sleep 5
done

echo $hashed_name is up and Running!
sleep 5
