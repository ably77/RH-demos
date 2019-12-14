

message="deploy this container"
command="oc create -f xyz"

read -p "Select 'y' to ${message}:" -n1 -s c
if [ "$c" = "y" ]; then
        echo yes
${command}

echo

else
        echo no
fi
