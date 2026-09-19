# Verification

`scripts/verify-langflow.sh` performs two checks:

1. `/health_check` verifies the application path that includes database and service checks for the pinned upstream version.
2. `/openapi.json` must be valid JSON with a title and at least one path.

Optional environment variables control timeouts and expected version:

```bash
export LANGFLOW_BASE_URL="http://127.0.0.1:7860"
export LANGFLOW_CONNECT_TIMEOUT_SECONDS="5"
export LANGFLOW_MAX_TIME_SECONDS="30"
export LANGFLOW_EXPECTED_VERSION="1.12.2"
./scripts/verify-langflow.sh
```

The script prints only a compact verification summary. It does not capture response bodies containing user flows, provider settings or credentials.

For container readiness on the pinned upstream version, `/healthz` is a better readiness endpoint than the generic `/health` route. Always re-check the upstream implementation when changing Langflow versions.
