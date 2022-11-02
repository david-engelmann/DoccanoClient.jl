#!/bin/bash
# Test Doccano Login
export DOCCANO_BASE_URL="http://localhost:8888"
export DOCCANO_USERNAME="admin"
export DOCCANO_PASSWORD="password"
julia test/test_Auth.jl
exec "$@"
