#!/bin/bash
# Let Doccano Finish Spinning Up
sleep 60

cat /etc/hosts

echo ""
echo "----------- test 172.18.0.3 -------------------"
ping -c 1 172.18.0.3 &> /dev/null
echo ""
echo ""
sleep 1

echo ""
echo "----------- test localhost --------------------"
ping -c 1 localhost &> /dev/null
echo ""
echo ""
sleep 1

echo ""
echo "----------- test http://172.18.0.3 -----------------"
if ping -c 1 http://172.18.0.1 &> /dev/null
then
  echo "Doccano Installed"
else
  echo "Doccano Installation Failed"
fi
echo ""
echo ""
sleep 1

echo ""
echo "--------- test http://172.18.0.1/admin/login/ -----------"
if ping -c 1 http://172.18.0.1/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
echo ""
echo ""
sleep 1
echo ""
echo ""
echo "--------- test http://0.0.0.0/admin/login/ -----------"
if ping -c 1 http://0.0.0.0/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
sleep 1
echo ""
echo ""
echo "--------- test http://localhost/admin/login/ -----------"
if ping -c 1 http://localhost/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
sleep 1
echo ""
echo ""
echo "--------- test http://172.18.0.3/admin/login/ -----------"
if ping -c 1 http://172.18.0.3/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
sleep 1
echo ""
echo ""
echo "------------ test doccano ---------------------"
ping -c 1 doccano
sleep 1
echo ""
echo ""
echo "------------ set PING_DOCCANO_ID with doccano from grep ------------------"
export PING_DOCCANO_ID=$(ping -c 1 doccano | grep -Po '(?<=\().*(?=\))' | grep -Po '.*(?=\))')
echo ""
echo ""
echo "------------ test ping PING_DOCCANO_ID ---------------------"
echo $PING_DOCCANO_ID
ping -c 1 $PING_DOCCANO_ID
sleep 1
echo ""
echo ""
echo "--------------------- test PING_DOCCANO_ID:6379 -----------------"
ping -c 1 $PING_DOCCANO_ID:6379
sleep 1
echo ""
echo ""

echo "--------------------- test PING_DOCCANO_ID:6379/tcp -----------------"
ping -c 1 $PING_DOCCANO_ID:6379/tcp
sleep 1
echo ""
echo ""
echo "------------ test ping http://PING_DOCCANO_ID + awk ---------------------"
echo $PING_DOCCANO_ID
ping -c 1 http://$PING_DOCCANO_ID
sleep 1
echo ""
echo ""
echo "--------------------- test http://PING_DOCCANO_ID:6379 -----------------"
ping -c 1 http://$PING_DOCCANO_ID:6379
sleep 1
echo ""
echo ""

echo "--------------------- test http://PING_DOCCANO_ID:6379/tcp -----------------"
ping -c 1 http://$PING_DOCCANO_ID:6379/tcp
sleep 1
echo ""
echo ""
echo "------------ test ping 0.0.0.0 ---------------------"
ping -c 1 0.0.0.0
sleep 1
echo ""
echo ""
echo "--------------------- test 0.0.0.0:6379 -----------------"
ping -c 1 0.0.0.0:6379
sleep 1
echo ""
echo ""
echo "--------------------- test http://0.0.0.0 ----------------"
ping -c 1 http://0.0.0.0
sleep 1
echo ""
echo ""
echo "-------------------- test http://0.0.0.0:6379 -----------------"
ping -c 1 http://0.0.0.0:6379
sleep 1
echo ""
echo ""

docker ps -a
docker ps --format "{{.ID}}: {{.Ports}}"
docker ps --format "{{.ID}}: {{.Image}}"
echo
echo
export PING_DOCKER_ID=$(docker ps | grep "doccano\s" | awk '{ print $1 }')
echo $PING_DOCKER_ID
echo
docker inspect $PING_DOCKER_ID
exec "$@"

