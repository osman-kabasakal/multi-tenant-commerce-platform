# Linux + Docker Compose deployment

Linux Docker Engine plus Docker Compose is the selected Production target. The container packaging below is implemented and verified in clean Linux CI; the complete fresh-server Compose bootstrap, ingress/DNS/TLS setup and restart/backup runbook are still being built. Do not treat an image build as proof of a complete hosting deployment. The existing local demo remains the ready-to-run cloud-free entry point.

## Build the committed server image

Use a non-root Linux deployment account with Docker access, Git, Python 3.10+ and Docker BuildKit. The build machine needs internet and at least 20 GiB of free disk for the separate .NET 8/9 SDK stages and Angular dependencies. The running server image contains the .NET 8/9 shared runtimes; it needs no host SDK or Node installation. Build for the target architecture explicitly:

```sh
python3 scripts/production_image.py build --image commerce-platform:local --platform linux/amd64
python3 scripts/production_image.py verify --image commerce-platform:local
```

On ARM64 Linux use `--platform linux/arm64`. The helper sets the image UID/GID to the current non-root operator; private 0700 directories and 0600 configuration/key bind mounts must belong to that account. The fresh PostgreSQL container probe can be run on Linux without host SDKs:

```sh
python3 scripts/smoke_production_image.py --image commerce-platform:local
```

The image is built from `git archive HEAD`, rather than the working directory. Commit intended changes first. Ignored local state, local configuration changes and Git history never enter this snapshot. A Docker context fence additionally excludes runtime settings, DataProtection keys, cloud credentials and signing material. `smoke_docker_context.py` checks the real Docker builder using disposable synthetic files and positive public-resource controls, following Docker's [build context rules](https://docs.docker.com/build/concepts/context/).

The runtime image is shared by separate processes. Its entrypoint accepts these explicit roles:

| Role | Process |
| --- | --- |
| `saas` | Actual SaaS API and published Angular frontend |
| `commerce` / `admin` | Shared tenant commerce/admin hosts |
| `gateway` | Owned-route gateway |
| `worker` | Portable provisioning worker; includes the standalone .NET 8 installer at `/app/installer/Grand.Installer.Cli.dll` |
| `mail-worker` | Independent readiness SMTP sender |
| `bootstrap` | Owner-only schema initialization or read-only verification |

Each application runs from its own `/app/<role>` directory with Production selected. Unknown roles are refused. No database credentials, encryption keys, certificate keys, tenants, cloud accounts or default store administrators are baked into the image. Mount component-specific private configuration and the shared deployment master key separately. Use the existing [component settings](PORTABLE_PROVISIONING.md), [database owner/runtime separation](DATABASE_BOOTSTRAP.md), [gateway boundaries](GATEWAY.md) and [SaaS settings](SAAS_PROVIDERS.md); they remain mandatory. The image contains no Flutter/JDK/Android SDK toolchain, so mobile release builds still use their separately configured build host/worker and signed-release CI.

## Verification scope

The dedicated [Production image workflow](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/workflows/production-image.yml) builds every actual server project and the Angular frontend from the exact commit on clean Ubuntu. It then executes the real runtime offline as non-root, checks both shared frameworks and required artifacts, runs the bootstrap entrypoint, and initializes/replays fresh isolated PostgreSQL schemas with a nonsuperuser owner and private key/config mounts. A different key must fail an independent verification container. Synthetic probe resources are removed. Exact source commit `c67735245e0af2fe38494ff9abec01db52d395b0` passed all of these actual image/container checks in [Ubuntu CI run 38863657306](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/runs/38863657306). This proves the server package and isolated database initialization, with the complete Compose rollout still pending.

The next deployment gate is a complete Compose installation that prepares infrastructure and private configuration, uses least-privilege runtime accounts, starts empty shared hosts, exposes only the intended HTTPS ingress, and provisions actual new businesses. Public DNS/certificates, live Google/Firebase/App Distribution and device delivery require their explicit operator configuration and separate verification.


## Complete Compose entry point (awaiting fresh Linux rollout verification)

The new `scripts/production.py` generates a private Compose definition, per-component settings, stable credentials and the master key. It starts PostgreSQL/MongoDB/Redis, creates separate schema-owner/SaaS/worker/reader/identity accounts, runs the existing owner bootstrap, grants runtime row privileges, and starts optimized PostgreSQL-backed Keycloak plus the actual application containers and Caddy HTTPS ingress. Only HTTP/HTTPS ingress ports are published. Backend proxy trust uses the explicit gateway/edge IPs in the dedicated Docker network. This complete path is under integration verification; the earlier successful image CI alone does not prove it.

Before startup, configure DNS for the portal/identity names and both tenant wildcard parents. Supply an existing valid certificate/full chain and matching private key covering all four targets. Choose an unused private Docker /24 subnet. Copy the example to ignored private configuration and edit its values; confirm wildcard DNS only after creating it:

```sh
mkdir -p .local
cp infra/production/deployment.example.json .local/production-input.json
# Edit the private input: domains, TLS files, trial plan, network and explicit providers.
python3 scripts/production.py up --config .local/production-input.json --state .local/production
python3 scripts/production.py verify --state .local/production
python3 scripts/production.py stop --state .local/production
```

Run startup as a non-root Linux account with Docker access. The command builds the committed server image and optimized Keycloak image when missing; no host Node/.NET SDK is required. `prepare` can validate/render settings without starting infrastructure. Repeated preparation preserves the installation record, master key and passwords. Existing Docker data/network without the matching installation id is refused. Missing original application databases/roles or changed deployment targets require explicit repair/backup restoration rather than silent reinitialization. Restart reuses the same owned data and forces application containers to reload their private settings. `stop` retains all data, keys and volumes.

The private state contains plaintext operator credentials and the common master key; keep the directory 0700, files 0600 and an access-controlled backup of both state and databases. Never commit it or remove it while keeping the database volumes. A verified consistent backup/restore runbook is still a separate deployment gate.

The default enables the configured zero-amount trial and creates no example stores, accounts or products. Keycloak public registration is disabled until the operator configures identity email delivery. Optional private input `Identity:RegistrationAllowed=true` requires `Identity:Smtp` in Keycloak's realm SMTP format; email verification remains enabled. Alternatively use the private identity administration API from the deployment operator host to manage verified accounts. Public identity routing excludes the master realm and administration console; the tenant provisioner can reach the target realm's administration API only from the owned Docker subnet. Account/self-registration browser verification and live email delivery remain separate checks.

`Providers:Google`, `Providers:Domains`, `Providers:ReadinessEmail` and `Providers:Notifications` are passed to the existing explicitly selected adapters. An optional private `GoogleCredentialsFile` (absolute ADC credential file path) is mounted only in the provisioning worker. Configure a separate `NotificationCredentialsFile` with the tenant notification sender permissions for the commerce/admin hosts; project creation/IAM credentials are never mounted there. These private files are never baked into the image. Disabled providers do not claim a successful cloud deployment. This baseline image does not include an Android toolchain, so the separately configured automatic mobile build host remains required; the complete Compose/Android worker packaging is not claimed here. Azure provider selection remains supported through the shared interfaces and standalone portable configuration, while this initial generated Compose profile uses AesGcm.

The fresh Linux probe runs `production.py up` against new owned resources, enrolls two real OIDC owners through SaaS, verifies each tenant’s actual storefront and owner administration login, repeats startup and checks public tenant readiness plus preserved SaaS/admin sessions, key and runtime privileges. Synthetic DNS is supplied through an isolated CONNECT fixture, with a private CA and strict end-to-end HTTPS; it does not change the hosts file or global trust. No real DNS/Google/SMTP account is used.
