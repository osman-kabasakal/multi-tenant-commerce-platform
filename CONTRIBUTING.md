# Contributing

Read `AGENTS.md`, `README.md`, `SECURITY.md` and the architecture notes first. Keep generated files, credentials and private customer data out of Git.

For local changes, run `python3 scripts/demo.py up` and `python3 scripts/demo.py smoke`. Build only the affected component while iterating. Record which flows you exercised and any unverified platform limitations. Keep cloud provisioning opt-in and separate from the local demo.

Use CodeGraph when an index is present. Do not commit `.codegraph/`. Preserve existing third-party notices, and resolve license provenance before adding external assets or code.
