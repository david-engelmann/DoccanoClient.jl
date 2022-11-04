#!/bin/bash
# Let Doccano Finish Spinning Up
sleep 60

cat /etc/hosts

echo ""
echo "----------- test 0.0.0.0 -------------------"
ping -c 1 0.0.0.0 &> /dev/null
echo
sleep 1

echo ""
echo "----------- test localhost --------------------"
ping -c 1 localhost &> /dev/null
echo
sleep 1

echo ""
echo "----------- test 0.0.0.0 -----------------"
if ping -c 1 0.0.0.0 &> /dev/null
then
  echo "Doccano Installed"
else
  echo "Doccano Installation Failed"
fi

echo ""
sleep 1

echo ""
echo "--------- test 0.0.0.0/admin/login -----------"
if ping -c 1 0.0.0.0/admin/login &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
docker ps -a
docker ps --format "{{.ID}}: {{.Ports}}"
docker ps --format "{{.Ports}}"
exec "$@"


