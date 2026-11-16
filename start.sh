#!/bin/bash
# Railway wrapper for Typesense: maps Railway's PORT and volume onto
# Typesense's own TYPESENSE_* settings, then starts the server.
set -euo pipefail

if [ -z "${TYPESENSE_API_KEY:-}" ]; then
  echo "TYPESENSE_API_KEY is not set. Refusing to start without an admin API key." >&2
  exit 1
fi

# Listen on Railway's PORT (the template sets 8108). "::" accepts IPv4 and
# IPv6, so both the public domain and the private network reach it.
export TYPESENSE_API_PORT="${PORT:-${TYPESENSE_API_PORT:-8108}}"
export TYPESENSE_API_ADDRESS="${TYPESENSE_API_ADDRESS:-::}"

# Data lives on the Railway volume (mounted at /data by the template).
export TYPESENSE_DATA_DIR="${TYPESENSE_DATA_DIR:-${RAILWAY_VOLUME_MOUNT_PATH:-/data}}"
mkdir -p "$TYPESENSE_DATA_DIR"

# Browsers (InstantSearch and similar) call Typesense directly.
export TYPESENSE_ENABLE_CORS="${TYPESENSE_ENABLE_CORS:-true}"

# Railway containers see all host cores. Typesense sizes its pools from the
# core count by default, which spawns hundreds of threads, so cap them.
export TYPESENSE_THREAD_POOL_SIZE="${TYPESENSE_THREAD_POOL_SIZE:-32}"
export TYPESENSE_NUM_COLLECTIONS_PARALLEL_LOAD="${TYPESENSE_NUM_COLLECTIONS_PARALLEL_LOAD:-8}"

echo "Starting Typesense on ${TYPESENSE_API_ADDRESS} port ${TYPESENSE_API_PORT}, data in ${TYPESENSE_DATA_DIR}"
exec /opt/typesense-server "$@"
