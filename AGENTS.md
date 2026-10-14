# Working on this monorepo

Work only in this repository. Do not modify the original source repositories.
Never commit `.local`, `.env`, signing keys, service-account JSON or credentials.

## CodeGraph

When `.codegraph/` exists, use CodeGraph before text search or file reads to locate or understand source code. Pass this repository as `projectPath` to the MCP tool, or use `codegraph explore` / `codegraph node --file` from this directory. Use ordinary reads for configuration and documentation that CodeGraph does not index. The index is local and ignored by Git.

## Local demo

The entry point is `python3 scripts/demo.py up`. Local adapters require Development and explicit `LocalDemo:Enabled`. Keep token verification and tenant isolation active. Cloud provisioning and mobile signing require separate, explicit configuration.
