# Runtime architecture

## FastAPI application

Langflow's backend is a FastAPI application assembled from routers, middleware, services and a lifespan hook. Startup prepares shared services such as persistence and configuration; shutdown releases the corresponding resources.

## Flow persistence

A visual Flow is persisted as structured data containing nodes and edges. Metadata supports listing and stable API exposure, while the graph payload is the source used to rebuild the executable workflow.

## Graph execution

The graph runtime tracks vertices, edges, dependencies and runnable nodes. It advances when dependencies are satisfied, executes the selected component, records its output and makes downstream vertices eligible.

## Graph loop versus agent loop

```text
Graph runtime chooses the next ready node
    -> an Agent component may call a model
        -> the model may request a tool
        -> backend executes the tool and returns its result
    -> Agent component finishes
    -> graph continues to downstream nodes
```

The outer loop is deterministic workflow scheduling; the inner loop may be model-directed. Keeping these responsibilities separate is important when debugging retries, state and latency.

## Source baseline

The exact upstream files used to verify this description are pinned in [`../UPSTREAM.md`](../UPSTREAM.md). This document is an independent architectural summary, not copied Langflow source code.
