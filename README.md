# Langflow Runtime Companion

用于本地启动和检查 Langflow 的配套脚本，附安装步骤和运行流程说明。脚本统一配置监听地址、数据目录和数据库位置，方便重复使用和排查启动问题。

本仓库包含两份 Bash 脚本和相关文档。实际的界面、API 和工作流执行功能由安装的官方 Langflow 提供。

## 使用

在 Bash 环境中运行，例如 Linux、macOS 或 Windows 的 WSL。验证脚本还需要 `curl` 和 `python3`。

先按 [部署说明](docs/deployment.md) 创建独立的 Python 环境并安装 Langflow，再启动：

```bash
./scripts/start-langflow.sh
```

默认配置：

- 访问地址：`http://127.0.0.1:7860`
- 虚拟环境：`$HOME/.venvs/langflow-runtime`
- 数据目录：`$HOME/.local/share/langflow-runtime`
- 数据库：数据目录下的 `langflow.db`
- 自动登录关闭，使用一个 worker

在另一个终端检查服务：

```bash
./scripts/verify-langflow.sh
```

验证脚本请求 `/health_check` 和 `/openapi.json`，检查 HTTP 请求是否成功，以及接口说明是否包含标题和路径。通过后输出标题、版本和 API 路径数。

## 修改配置

脚本从环境变量读取配置。需要更换目录或端口时，可以在启动前设置：

```bash
export LANGFLOW_VENV_DIR="$HOME/.venvs/langflow-runtime"
export LANGFLOW_DATA_DIR="$HOME/.local/share/langflow-runtime"
export LANGFLOW_HOST="127.0.0.1"
export LANGFLOW_PORT="7860"

./scripts/start-langflow.sh
```

验证其他地址，或指定预期版本：

```bash
export LANGFLOW_BASE_URL="http://127.0.0.1:7860"
export LANGFLOW_EXPECTED_VERSION="1.12.2"
export LANGFLOW_CONNECT_TIMEOUT_SECONDS="5"
export LANGFLOW_MAX_TIME_SECONDS="30"

./scripts/verify-langflow.sh
```

本地使用保持监听 `127.0.0.1` 即可。需要远程访问时，请先按所用 Langflow 版本配置认证、TLS 和访问控制。真实模型密钥通过 Langflow 支持的配置方式或进程环境提供，不提交到仓库。

## 文件说明

| 文件 | 用途 |
| --- | --- |
| [scripts/start-langflow.sh](scripts/start-langflow.sh) | 检查启动配置、设置数据目录并运行 Langflow |
| [scripts/verify-langflow.sh](scripts/verify-langflow.sh) | 检查服务健康状态和 OpenAPI 文档 |
| [docs/deployment.md](docs/deployment.md) | 安装环境、启动服务和配置凭据 |
| [docs/verification.md](docs/verification.md) | 验证方式、超时设置和健康检查入口 |
| [docs/architecture.md](docs/architecture.md) | 说明 FastAPI、Flow 数据、图调度和 Agent 工具调用的关系 |
| [UPSTREAM.md](UPSTREAM.md) | 记录参考版本及对应的官方源码位置 |

## 参考版本与许可

脚本和架构说明以官方 [Langflow](https://github.com/langflow-ai/langflow) `v1.12.2` 为基线，对应提交：

`c979695ce660285b267b3e7c6788e91aade3c0fe`

更换 Langflow 版本后，需要重新确认启动参数和健康检查接口。具体参考位置见 [UPSTREAM.md](UPSTREAM.md)。

本仓库的配套脚本和文档采用 [MIT License](LICENSE)。Langflow 的来源、许可及归属说明见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) 和 [LICENSES/Langflow-MIT.txt](LICENSES/Langflow-MIT.txt)。
