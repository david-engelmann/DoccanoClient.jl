#!/bin/bash
export DOCCANO_BASE_URL="http://${PING_DOCCANO_ID}:6379/"
export DOCCANO_USERNAME="admin"
export DOCCANO_PASSWORD="password"
julia test/test_Full.jl
exec "$@"
exec "$@"
