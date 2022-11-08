#!/bin/bash
# Let Doccano Finish Spinning Up
sleep 60

cat /etc/hosts

echo ""
echo ""
echo "--------- test http://172.18.0.3:6379/admin/login/ -----------"
if ping -c 1 http://172.18.0.3:6379/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
sleep 10
echo ""
echo ""
echo "--------- test http://doccano:6379/admin/login/ -----------"
if ping -c 1 http://doccano:6379/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
sleep 10
echo ""
echo ""
echo "------------ set PING_DOCCANO_ID with doccano from grep ------------------"
export PING_DOCCANO_ID=$(ping -c 1 doccano | grep -Po '(?<=\().*(?=\))' | grep -Po '.*(?=\))')
echo ""
echo ""
echo "------------ test ping PING_DOCCANO_ID ---------------------"
echo "PING_DOCCANO_ID=$PING_DOCCANO_ID" >> $GITHUB_ENV
echo ""
echo ""
echo "--------------------- test http://PING_DOCCANO_ID:6379/ -----------------"
ping -c 1 http://$PING_DOCCANO_ID:6379/
sleep 10
export PING_DOCKER_ID=$(docker ps | grep "doccano\s" | awk '{ print $1 }')
echo "PING_DOCKER_ID=$PING_DOCKER_ID" >> $GITHUB_ENV 
exec "$@"