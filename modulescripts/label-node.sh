node=ip-10-0-166-49.us-west-2.compute.internal
key=kubernetes.io/os
value=linux

oc label node ${node} ${key}=${value}
