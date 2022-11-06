#!/bin/bash
# Test Doccano Login
echo "Test Login"
export DOCCANO_BASE_URL="doccano"
export DOCCANO_USERNAME="admin"
export DOCCANO_PASSWORD="password"
julia test/test_Auth.jl
exec "$@"
