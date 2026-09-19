# Deployment

## 1. Create an isolated environment

Use a Python version supported by the Langflow release you selected, then create a dedicated virtual environment. Do not install Langflow into a project-wide environment shared with unrelated applications.

```bash
python3 -m venv "$HOME/.venvs/langflow-runtime"
"$HOME/.venvs/langflow-runtime/bin/python" -m pip install --upgrade pip
"$HOME/.venvs/langflow-runtime/bin/python" -m pip install "langflow==1.12.2"
```

## 2. Start locally

The startup script defaults to loopback networking, one worker and a SQLite file under an isolated data directory. The script does not store model credentials.

```bash
./scripts/start-langflow.sh
```

## 3. Authentication and network exposure

`LANGFLOW_AUTO_LOGIN` is false by default. Keep the service on `127.0.0.1` for local development. Before exposing it through a reverse proxy or remote host, configure authentication, TLS, access controls and secret management according to the selected Langflow release.

## 4. Provider credentials

Configure credentials through Langflow's supported secret mechanism or process environment. Never put a real API key into a flow export, shell script, repository `.env`, screenshot or verification log.
