#!/bin/bash
# Let Doccano Finish Spinning Up
sleep 60
# Test the Doccano Instance with ping
if ping -c 1 http://localhost &> /dev/null
then
  echo "Doccano Installed"
else
  echo "Doccano Installation Failed"
fi

if ping -c 1 http://localhost/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
exec "$@"
