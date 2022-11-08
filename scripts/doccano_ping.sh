#!/bin/bash
echo "------------ set PING_DOCCANO_ID with doccano from grep ------------------"
export PING_DOCCANO_ID=$(ping -c 1 doccano | grep -Po '(?<=\().*(?=\))' | grep -Po '.*(?=\))')
echo ""
echo "------------ test ping PING_DOCCANO_ID ---------------------"
echo "PING_DOCCANO_ID=$PING_DOCCANO_ID" >> $GITHUB_ENV
echo ""
echo "--------- test http://$PING_DOCCANO_ID:6379/admin/login/ -----------"
if ping -c 1 http://$PING_DOCCANO_ID:6379/admin/login/ &> /dev/null
then
  echo "Doccano Admin Accessable"
else
  echo "Doccano Admin Access Failed"
fi
sleep 10
export PING_DOCKER_ID=$(docker ps | grep "doccano\s" | awk '{ print $1 }')
echo "PING_DOCKER_ID=$PING_DOCKER_ID" >> $GITHUB_ENV 
exec "$@"