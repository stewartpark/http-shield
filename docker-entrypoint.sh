#!/bin/sh

set -e

if [ -n "$DEBUG" ]; then
    cat /etc/haproxy/haproxy.cfg
fi

if [ -z "$SERVER_PORT" ]; then
    export SERVER_PORT=3000
fi

if [ -z "$SHIELD_PORT" ]; then
    export SHIELD_PORT=8080
fi

_sigint() {
    echo "Caught SIGINT signal! Shutting down..."
    kill -INT "$PID" 2> /dev/null
    sleep 1
}

_sigterm() {
    echo "Caught SIGTERM signal! Shutting down..."
    kill -TERM "$PID" 2> /dev/null
    sleep 1
}

trap _sigint INT
trap _sigterm TERM

echo "[+] Generating config files..."
confd -onetime -backend env

echo "[+] Listening on :${SHIELD_PORT} to forward requests to :${SERVER_PORT}..."
haproxy -f /etc/haproxy/haproxy.cfg &
PID=$!

wait "$PID"
