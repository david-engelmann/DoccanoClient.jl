#!/bin/bash
# Let Doccano Finish Spinning Up
sleep 60

cat /etc/hosts

echo ""
echo "----------- test 172.18.0.3 -------------------"
ping -c 1 172.18.0.3 &> /dev/null
echo ""
echo ""
sleep 10

echo ""
echo "----------- test localhost --------------------"
ping -c 1 localhost &> /dev/null
echo ""
echo ""
sleep 10

echo ""
echo "----------- test http://172.18.0.1 -----------------"
if ping -c 1 http://172.18.0.1 &> /dev/null
then
  echo "Doccano Installed"
else
  echo "Doccano Installation Failed"
fi
echo ""
echo ""
sleep 10

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
sleep 10
echo ""
echo ""
echo "--------- test http://0.0.0.0/admin/login/ -----------"
if ping -c 1 http://0.0.0.0/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
sleep 10
echo ""
echo ""
echo "--------- test http://localhost/admin/login/ -----------"
if ping -c 1 http://localhost/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
sleep 10
echo ""
echo ""
echo "--------- test http://172.18.0.3/admin/login/ -----------"
if ping -c 1 http://172.18.0.3/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
sleep 10
echo ""
echo ""
echo "------------ test doccano ---------------------"
ping -c 1 doccano
sleep 10
echo ""
echo ""
echo "------------ test doccano:6379 ---------------------"
ping -c 1 doccano:6379
sleep 10
echo ""
echo ""
echo "------------ test doccano/admin/login ---------------------"
ping -c 1 doccano/admin/login/
sleep 10
echo ""
echo ""
echo "------------ test doccano:6379/admin/login ---------------------"
ping -c 1 doccano:6379/admin/login/
sleep 10
echo ""
echo ""
echo "------------ test http://doccano ---------------------"
ping -c 1 http://doccano
sleep 10
echo ""
echo ""
echo "------------ test http://doccano:6379 ---------------------"
ping -c 1 http://doccano:6379
sleep 10
echo ""
echo ""
echo "------------ test http://doccano/admin/login ---------------------"
ping -c 1 http://doccano/admin/login/
sleep 10
echo ""
echo ""
echo "------------ test http://doccano:6379/admin/login ---------------------"
ping -c 1 http://doccano:6379/admin/login/
sleep 10
echo ""
echo ""
echo "------------ set PING_DOCCANO_ID with doccano from grep ------------------"
export PING_DOCCANO_ID=$(ping -c 1 doccano | grep -Po '(?<=\().*(?=\))' | grep -Po '.*(?=\))')
echo ""
echo ""
echo "------------ test ping PING_DOCCANO_ID ---------------------"
echo "PING_DOCCANO_ID=$PING_DOCCANO_ID" >> $GITHUB_ENV
ping -c 1 $PING_DOCCANO_ID
sleep 10
echo ""
echo ""
echo "--------------------- test PING_DOCCANO_ID:6379 -----------------"
ping -c 1 $PING_DOCCANO_ID:6379
sleep 10
echo ""
echo ""

echo "--------------------- test PING_DOCCANO_ID:6379/tcp -----------------"
ping -c 1 $PING_DOCCANO_ID:6379/tcp
sleep 10
echo ""
echo ""
echo "------------ test ping http://PING_DOCCANO_ID + awk ---------------------"
ping -c 1 http://$PING_DOCCANO_ID
sleep 10
echo ""
echo ""
echo "--------------------- test http://PING_DOCCANO_ID:6379 -----------------"
ping -c 1 http://$PING_DOCCANO_ID:6379
sleep 10
echo ""
echo ""

echo "--------------------- test http://PING_DOCCANO_ID:6379/tcp -----------------"
ping -c 1 http://$PING_DOCCANO_ID:6379/tcp
sleep 10
echo ""
echo ""
echo "------------ test ping 127.0.0.1 ---------------------"
ping -c 1 127.0.0.1
sleep 10
echo ""
echo ""
echo "--------------------- test 127.0.0.1:6379 -----------------"
ping -c 1 127.0.0.1:6379
sleep 10
echo ""
echo ""
echo "--------------------- test http://127.0.0.1 ----------------"
ping -c 1 http://127.0.0.1
sleep 10
echo ""
echo ""
echo "-------------------- test http://127.0.0.1:6379 -----------------"
ping -c 1 http://127.0.0.1:6379
sleep 10
echo ""
echo ""

docker ps -a
docker ps --format "{{.ID}}: {{.Ports}}"
docker ps --format "{{.ID}}: {{.Image}}"
echo
echo
export PING_DOCKER_ID=$(docker ps | grep "doccano\s" | awk '{ print $1 }')
echo "PING_DOCKER_ID=$PING_DOCKER_ID" >> $GITHUB_ENV 
echo
docker inspect $PING_DOCKER_ID
exec "$@"

