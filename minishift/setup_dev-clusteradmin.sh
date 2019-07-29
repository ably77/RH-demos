
#!/bin/bash

password=nothing1

# Login as admin
oc login -u system:admin

# Select default project space
oc project default

# Create a developer user with cluster-admin rights
oc create user developer

# Add cluster-admin rights to developer
oc policy add-role-to-user cluster-admin developer
oc policy add-role-to-user admin developer

# Login as developer
oc login -u developer -p developer
