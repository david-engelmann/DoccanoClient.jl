#!/bin/bash
# Test Doccano Login
DOCCANO_BASE_URL=localhost
DOCCANO_USERNAME="admin"
DOCCANO_PASSWORD="password"
julia test/test_Auth.jl
exec "$@"