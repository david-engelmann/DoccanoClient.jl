#!/bin/bash
# Test Doccano Login
export DOCCANO_BASE_URL="http://127.0.0.1:8000"
export DOCCANO_USERNAME="admin"
export DOCCANO_PASSWORD="password"
julia test/test_Auth.jl
exec "$@"