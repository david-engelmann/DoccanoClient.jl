#!/bin/bash
# Let Doccano Finish Spinning Up
sleep 60
# Test the Doccano Instance with ping
if ping -c 1 http://127.0.0.1 &> /dev/null
then
  echo "Doccano Installed"
else
  echo "Doccano Installation Failed"
fi
exec "$@"