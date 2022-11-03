#!/bin/bash
# Let Doccano Finish Spinning Up
sleep 60

cat /etc/hosts
# Test the Doccano Instance with ping
echo "----------- test localhost -----------"
ping -c 1 http://localhost &> /dev/null

echo ""
echo "----------- test localhost:8000 -------------"
ping -c 1 http://localhost:8000

echo ""
echo "----------- test localhost:8888 --------------"
ping -c 1 http://localhost:8888 &> /dev/null

echo ""
echo "----------- test 0.0.0.0:8888 -----------------"
ping -c 1 http://0.0.0.0:8888 &> /dev/null

echo ""
echo "----------- test 0.0.0.0:8000 -----------------"
if ping -c 1 http://0.0.0.0:8000 &> /dev/null
then
  echo "Doccano Installed"
else
  echo "Doccano Installation Failed"
fi

echo ""

if ping -c 1 http://0.0.0.0:8000/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
exec "$@"
