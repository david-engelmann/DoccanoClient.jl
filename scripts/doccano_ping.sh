#!/bin/bash
# Let Doccano Finish Spinning Up
sleep 60

cat /etc/hosts

echo ""
echo "----------- test 172.18.0.1:8000/tcp -------------------"
ping -c 1 172.18.0.1:8000/tcp &> /dev/null
echo
sleep 1

echo ""
echo "----------- test localhost --------------------"
ping -c 1 localhost &> /dev/null
echo
sleep 1

echo ""
echo "----------- test 172.18.0.1:8000/tcp -----------------"
if ping -c 1 172.18.0.1:8000/tcp &> /dev/null
then
  echo "Doccano Installed"
else
  echo "Doccano Installation Failed"
fi

echo ""
sleep 1

echo ""
echo "--------- test 172.18.0.1:8000/tcp/admin/login -----------"
if ping -c 1 172.18.0.1:8000/tcp/admin/login &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
docker ps -a
docker ps --format "{{.ID}}: {{.Ports}}"
docker ps --format "{{.ID}}: {{.Image}}"
echo
echo
PING_DOCKER_ID=$(docker ps | grep "doccano\s" | awk '{ print $1 }')
echo $PING_DOCKER_ID
echo
docker inspect $PING_DOCKER_ID
echo "--------- post grep -----------------"
echo
PING_DOCKER_IDS_FILTER=$(docker ps)
echo $PING_DOCKER_IDS_FILTER
exec "$@"

