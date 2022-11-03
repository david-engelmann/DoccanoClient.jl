#!/bin/bash
# Test Doccano Login
echo "Login Test"
export DOCCANO_BASE_URL="localhost"
export DOCCANO_USERNAME="admin"
export DOCCANO_PASSWORD="password"
julia test/test_Auth.jl
exec "$@"
