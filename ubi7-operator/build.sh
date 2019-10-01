#!/bin/bash

user=ally

### Input version
read -p "Input Version: " version

operator-sdk build quay.io/${user}/ubi7-operator:v0.${version}

docker push quay.io/${user}/ubi7-operator:v0.${version}
