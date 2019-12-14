#!/bin/bash

node_name=$1
key=$2

oc adm taint nodes ${node_name} ${key}-
