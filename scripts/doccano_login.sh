#!/bin/bash
# Test Doccano Login
echo "Test Login"
echo "----------- Doccano Ip Address ------------"
echo ${PING_DOCCANO_ID}
echo ""
echo ""
echo "----------- Doccano Docker ID"
echo ${PING_DOCKER_ID}
export DOCCANO_BASE_URL="http://${PING_DOCCANO_ID}/"
echo $DOCCANO_BASE_URL
export DOCCANO_BASE_URL="http://127.0.0.1/"
export DOCCANO_USERNAME="admin"
export DOCCANO_PASSWORD="password"
julia test/test_Auth.jl
exec "$@"
