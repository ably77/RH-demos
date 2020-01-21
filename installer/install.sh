#!/bin/bash

mkdir $HOME/Desktop/ly-demo

cp $HOME/Desktop/installer/install-config.yaml $HOME/Desktop/ly-demo

./openshift-install_4.2stable create cluster --dir=$HOME/Desktop/ly-demo --log-level debug

#git clone https://github.com/ably77/RH-demos.git $HOME/Desktop/ly-demo/RH-Demos
#git clone https://github.com/ably77/strimzi-openshift-demo.git $HOME/Desktop/ly-demo/strimzi-openshift-demo


### open console route
open https://console-openshift-console.apps.ly-demo.openshiftaws.com

### setup new tab for iterm2
newtabi(){  
  osascript \
    -e 'tell application "iTerm2" to tell current window to set newWindow to (create tab with default profile)'\
    -e "tell application \"iTerm2\" to tell current session of newWindow to write text \"${@}\""
}

newtabi 'export KUBECONFIG=/Users/alexly/Desktop/ly-demo/auth/kubeconfig && cd $HOME/Desktop/strimzi-openshift-demo && ./runme.sh'
