#!/bin/bash
# Test Doccano Login
export DOCCANO_BASE_URL=localhost
export DOCCANO_USERNAME="admin"
export DOCCANO_PASSWORD="password"
julia test/test_Auth.jl
exec "$@"