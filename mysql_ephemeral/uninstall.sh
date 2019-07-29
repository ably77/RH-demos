#!/bin/bash

### Uninstall mysql
oc delete all,configmap,pvc,serviceaccount,rolebinding,secrets --selector app=mysql
