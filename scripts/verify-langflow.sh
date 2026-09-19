#!/usr/bin/env bash

set -euo pipefail

BASE_URL="${LANGFLOW_BASE_URL:-http://127.0.0.1:7860}"
CONNECT_TIMEOUT="${LANGFLOW_CONNECT_TIMEOUT_SECONDS:-5}"
MAX_TIME="${LANGFLOW_MAX_TIME_SECONDS:-30}"
EXPECTED_VERSION="${LANGFLOW_EXPECTED_VERSION:-}"
OPENAPI_FILE="$(mktemp)"

cleanup() {
    rm -f "$OPENAPI_FILE"
}
trap cleanup EXIT

echo "Checking database-aware health endpoint"
curl --fail --silent --show-error \
    --connect-timeout "$CONNECT_TIMEOUT" \
    --max-time "$MAX_TIME" \
    "$BASE_URL/health_check"
echo

echo "Checking OpenAPI document"
curl --fail --silent --show-error \
    --connect-timeout "$CONNECT_TIMEOUT" \
    --max-time "$MAX_TIME" \
    --output "$OPENAPI_FILE" \
    "$BASE_URL/openapi.json"

python3 - "$OPENAPI_FILE" "$EXPECTED_VERSION" <<'PY'
import json
import sys
from pathlib import Path

document = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
info = document.get("info", {})
title = info.get("title")
version = info.get("version")
path_count = len(document.get("paths", {}))

if not title or path_count == 0:
    raise SystemExit("OpenAPI document is missing a title or API paths")

expected_version = sys.argv[2]
if expected_version and version != expected_version:
    raise SystemExit(f"expected version {expected_version!r}, got {version!r}")

print(f"title={title}")
print(f"version={version}")
print(f"paths={path_count}")
PY
