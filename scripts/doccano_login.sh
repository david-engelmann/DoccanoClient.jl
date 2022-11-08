#!/bin/bash
# Test Doccano Login
echo "Test Login"
echo "----------- Doccano Ip Address ------------"
echo ${PING_DOCCANO_ID}
echo ""
echo "----------- Doccano Docker ID"
echo ${PING_DOCKER_ID}
export DOCCANO_BASE_URL="http://${PING_DOCCANO_ID}:6379/"
echo $DOCCANO_BASE_URL
#export DOCCANO_BASE_URL="http://doccano:6379/"
export DOCCANO_USERNAME="admin"
export DOCCANO_PASSWORD="password"
julia test/test_Auth.jl
exec "$@"
