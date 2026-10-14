# Security and disclosure

Do not put credentials, customer data or exploit details in a public issue. Until a private reporting channel is configured, contact the repository owner privately.

## Snapshot preparation

- Original repositories are read-only inputs; this repository has fresh history.
- Service-account JSON, Firebase project configuration, certificates, mobile signing keys, runtime configuration, compiled outputs, user-secret IDs and customer datasets were excluded.
- Literal credentials found in source were replaced with explicit placeholders or configuration lookups.
- Local passwords and cryptographic keys are generated under `.local/`, with restricted file permissions on Unix. They are never committed.
- Token and tenant checks remain active; local adapters require Development.
- `scripts/check_public_source.py` checks tracked filenames and Gitleaks scans tracked content in CI.

A clean scanner result does not prove that all secrets or vulnerabilities have been found. The source snapshot was prepared for a local demo, not subjected to a complete independent security audit. Existing provider integrations require review before a public/cloud deployment.

Removing secrets from this snapshot does **not** revoke any credentials previously present in the original repositories or their histories. Rotate those original credentials through the issuing providers before publishing any related history. Do not copy the old `.git` directories into this repository.
