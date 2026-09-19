#!/usr/bin/env bash

set -euo pipefail

VENV_DIR="${LANGFLOW_VENV_DIR:-$HOME/.venvs/langflow-runtime}"
DATA_DIR="${LANGFLOW_DATA_DIR:-$HOME/.local/share/langflow-runtime}"
HOST="${LANGFLOW_HOST:-127.0.0.1}"
PORT="${LANGFLOW_PORT:-7860}"
AUTO_LOGIN="${LANGFLOW_AUTO_LOGIN:-false}"
LANGFLOW_BIN="${LANGFLOW_BIN:-$VENV_DIR/bin/langflow}"

if [[ "$AUTO_LOGIN" == "true" && "$HOST" != "127.0.0.1" && "$HOST" != "localhost" ]]; then
    echo "Refusing to enable auto-login on a non-loopback address." >&2
    exit 2
fi

if [[ ! -x "$LANGFLOW_BIN" ]]; then
    echo "Langflow executable not found: $LANGFLOW_BIN" >&2
    echo "Set LANGFLOW_BIN or install Langflow in LANGFLOW_VENV_DIR." >&2
    exit 3
fi

mkdir -p "$DATA_DIR"

export LANGFLOW_CONFIG_DIR="$DATA_DIR"
export LANGFLOW_DATABASE_URL="sqlite+aiosqlite:///$DATA_DIR/langflow.db"
export LANGFLOW_AUTO_LOGIN="$AUTO_LOGIN"
export DO_NOT_TRACK="${DO_NOT_TRACK:-true}"

echo "Starting Langflow at http://$HOST:$PORT"
echo "Runtime data: $DATA_DIR"

exec "$LANGFLOW_BIN" run \
    --host "$HOST" \
    --port "$PORT" \
    --workers 1 \
    --no-open-browser
