minishift start -p knative --memory=8192 --cpus=4 \
  --kubernetes-version=v1.12.0 \
  --vm-driver=kvm2 \
  --disk-size=20g \
  --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
