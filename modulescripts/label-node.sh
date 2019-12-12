node=$1
key=kubernetes.io/os
value=linux

oc label node ${node} ${key}=${value}
