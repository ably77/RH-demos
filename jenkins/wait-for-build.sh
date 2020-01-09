#!/bin/bash

seconds=0
OUTPUT=0
build_name=$1
namespace=$2

while [ "$OUTPUT" -ne 1 ]; do
  OUTPUT=`oc get dc/${build_name} 2>/dev/null | grep -c ${build_name}`;
  seconds=$((seconds+10))
  printf "Waiting %s seconds for deployment config ${build_name} to come up.\n" "${seconds}"
  sleep 10
done

oc rollout status dc/${build_name} -n ${namespace}
