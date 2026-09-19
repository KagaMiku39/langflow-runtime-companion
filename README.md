# Langflow Runtime Companion

一个独立维护的 Langflow 本地部署、健康检查与运行链路说明仓库。它不复制 Langflow 主仓库，也不把上游功能声明为个人实现；这里保存的是本人编写的安全启动脚本、可复核验证脚本和架构说明。

> 本项目不是 Langflow 官方项目，也不代表参与 Langflow 核心开发。验证基线为 Langflow `v1.12.2`，commit `c979695ce660285b267b3e7c6788e91aade3c0fe`。完整来源和许可见 [`UPSTREAM.md`](UPSTREAM.md) 与 [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md)。

## 为什么做

直接运行 `langflow run` 可以看到界面，却不容易判断数据目录、数据库、监听地址和真实健康状态是否正确。本仓库把这些部署细节固定成可审查脚本，并把 FastAPI 入口、Flow 数据和 Graph Runtime 的职责拆开说明。

## 怎么做

- `scripts/start-langflow.sh` 将虚拟环境、数据目录、地址、端口和登录策略全部参数化。
- 默认仅监听 `127.0.0.1`，并默认关闭自动登录；脚本会拒绝“公网监听 + 自动登录”的危险组合。
- SQLite、配置和运行数据集中到独立目录，不污染官方源码 checkout。
- `scripts/verify-langflow.sh` 检查 `/health_check` 与 `/openapi.json`，设置连接和总超时，并输出标题、版本与接口数量。
- 文档记录 Langflow 的图工作流执行链，同时明确区分“图决定节点顺序”与“模型决定工具调用”。

## 结果

- 可在不修改官方仓库的前提下重复启动与验证 Langflow。
- 健康检查使用官方实现中的综合检查入口，而不是容易被 Uvicorn 提前响应的 `/health`。
- 所有脚本不包含本机用户名、绝对路径、API Key 或数据库密码。

## 使用

先按 [`docs/deployment.md`](docs/deployment.md) 安装与配置 Langflow，然后运行：

```bash
./scripts/start-langflow.sh
```

在另一个终端验证：

```bash
./scripts/verify-langflow.sh
```

常用可选配置：

```bash
export LANGFLOW_VENV_DIR="$HOME/.venvs/langflow-runtime"
export LANGFLOW_DATA_DIR="$HOME/.local/share/langflow-runtime"
export LANGFLOW_HOST="127.0.0.1"
export LANGFLOW_PORT="7860"
```

## 内容边界

本仓库没有包含 Langflow 官方 Python/TypeScript 源码、前端资源或 Git 历史。需要阅读或贡献 Langflow 本身时，请使用官方仓库；需要展示个人工程能力时，可引用本仓库中的启动、验证、归属和架构梳理工作。
