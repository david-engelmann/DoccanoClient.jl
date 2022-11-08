#!/bin/bash
# Test Doccano Login
echo "Test Login"
echo "----------- Doccano Ip Address ------------"
echo ${PING_DOCCANO_ID}
export DOCCANO_BASE_URL="http://${PING_DOCCANO_ID}:6379/"
export DOCCANO_USERNAME="admin"
export DOCCANO_PASSWORD="password"
julia test/test_Auth.jl
exec "$@"
