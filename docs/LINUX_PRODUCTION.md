# Linux + Docker Compose deployment

Linux Docker Engine plus Docker Compose is the selected Production target. The container packaging below is implemented; the complete fresh-server Compose bootstrap, ingress/DNS/TLS setup and restart/backup runbook are still being built. Do not treat an image build as proof of a complete hosting deployment. The existing local demo remains the ready-to-run cloud-free entry point.

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

The dedicated [Production image workflow](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/workflows/production-image.yml) builds every actual server project and the Angular frontend from the exact commit on clean Ubuntu. It then executes the real runtime offline as non-root, checks both shared frameworks and required artifacts, runs the bootstrap entrypoint, and initializes/replays fresh isolated PostgreSQL schemas with a nonsuperuser owner and private key/config mounts. A different key must fail an independent verification container. Synthetic probe resources are removed. Check the exact run result in [VALIDATION.md](VALIDATION.md); workflow presence alone does not prove these checks passed.

The next deployment gate is a complete Compose installation that prepares infrastructure and private configuration, uses least-privilege runtime accounts, starts empty shared hosts, exposes only the intended HTTPS ingress, and provisions actual new businesses. Public DNS/certificates, live Google/Firebase/App Distribution and device delivery require their explicit operator configuration and separate verification.
