# Linux + Docker Compose deployment

Linux Docker Engine plus Docker Compose is the selected Production target. Clean Linux CI has verified the complete cloud-free baseline: fresh infrastructure, actual SaaS enrollment, two new tenant storefronts and administrator logins, and a restart preserving data, keys and sessions. This uses isolated synthetic DNS and valid private-CA HTTPS; consistent cold database/private-state restoration also passed its full Linux gate. Live public DNS/cloud/device delivery still requires separate verification. The existing local demo is also a ready-to-run cloud-free entry point.

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

The patched .NET 8/9 runtimes require a private writable directory for named image locks. The image sets `XDG_RUNTIME_DIR=/run/platform-runtime`; Compose mounts it as a per-container 0700 tmpfs owned by the deployment UID/GID. The offline verifier executes actual mutex creation/release under both frameworks with the root filesystem read-only. This follows the [runtime maintainers’ documented directory requirement](https://github.com/dotnet/runtime/issues/135726).

The runtime image is shared by separate processes. Its entrypoint accepts these explicit roles:

| Role | Process |
| --- | --- |
| `saas` | Actual SaaS API and published Angular frontend |
| `commerce` / `admin` | Shared tenant commerce/admin hosts |
| `gateway` | Owned-route gateway |
| `worker` | Portable provisioning worker; includes the standalone .NET 8 installer at `/app/installer/Grand.Installer.Cli.dll` |
| `mail-worker` | Independent readiness SMTP sender |
| `bootstrap` | Owner-only schema initialization or read-only verification |
| `cloud` | Explicit Google access checks, public SDK export or configured release distribution |

Each application runs from its own `/app/<role>` directory with Production selected. Unknown roles are refused. No database credentials, encryption keys, certificate keys, tenants, cloud accounts or default store administrators are baked into the image. Mount component-specific private configuration and the shared deployment master key separately. Use the existing [component settings](PORTABLE_PROVISIONING.md), [database owner/runtime separation](DATABASE_BOOTSTRAP.md), [gateway boundaries](GATEWAY.md) and [SaaS settings](SAAS_PROVIDERS.md); they remain mandatory. The image contains no Flutter/JDK/Android SDK toolchain, and uses the optional Android worker image below for automatic mobile builds. The complete signed Flutter release inside that worker image passed clean Linux CI as recorded below.

## Verification scope

The dedicated [Production image workflow](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/workflows/production-image.yml) builds every actual server project and the Angular frontend from the exact commit on clean Ubuntu. It then executes the real runtime offline as non-root, checks both shared frameworks and required artifacts, runs the bootstrap and cloud-help entrypoints offline, and initializes/replays fresh isolated PostgreSQL schemas with a nonsuperuser owner and private key/config mounts. A different key must fail an independent verification container. Synthetic probe resources are removed. Exact source commit `c67735245e0af2fe38494ff9abec01db52d395b0` passed all of these actual image/container checks in [Ubuntu CI run 38863657306](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/runs/38863657306). That run proves the server package and isolated database initialization. The subsequent exact source `9dce1423031f658a77ff08805a4b93817a769da9` also passed the complete actual Compose rollout in [Linux CI run 38878692968](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/runs/38878692968), including actual storefront HTML/admin logins and state-preserving restart.

The verified Compose baseline prepares infrastructure and private configuration, uses least-privilege runtime accounts, starts empty shared hosts, exposes only the intended HTTPS ingress, and provisions actual new businesses. Public DNS/certificates, live Google/Firebase/App Distribution and device delivery require their explicit operator configuration and separate verification. Real Angular/self-registration, private SMTP verification and browser restart also passed [exact-source CI](VALIDATION.md#verified-real-registration-and-linux-restart-2026-10-16). Cold database restoration passed its own [complete acceptance gate](BACKUP_RESTORE.md).


## Complete Compose entry point

The new `scripts/production.py` generates a private Compose definition, per-component settings, stable credentials and the master key. It starts PostgreSQL/MongoDB/Redis, creates separate schema-owner/SaaS/worker/reader/identity accounts, runs the existing owner bootstrap, grants runtime row privileges, and starts optimized PostgreSQL-backed Keycloak plus the actual application containers and Caddy HTTPS ingress. Only HTTP/HTTPS ingress ports are published. Backend proxy trust uses the explicit gateway/edge IPs in the dedicated Docker network. The complete cloud-free two-owner path passed the exact Linux Compose run linked above; the real browser/self-registration gate also passed the exact-source verification recorded below.

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

The private state contains plaintext operator credentials and the common master key; keep the directory 0700, files 0600 and an access-controlled backup of both state and databases. Never commit it or remove it while keeping the database volumes. The [cold snapshot and restore tool](BACKUP_RESTORE.md) preserves state/databases together; its actual Linux restore gate passed against an empty disposable destination with original keys and sessions preserved.

The default enables the configured zero-amount trial and creates no example stores, accounts or products. Keycloak public registration is disabled until the operator configures identity email delivery. Optional private input `Identity:RegistrationAllowed=true` requires `Identity:Smtp` in Keycloak's realm SMTP format; email verification remains enabled. Alternatively use the private identity administration API from the deployment operator host to manage verified accounts. Public identity routing excludes the master realm and administration console; the tenant provisioner can reach the target realm's administration API only from the owned Docker subnet. To enable owner self-registration, merge `infra/production/identity.example.json` into the ignored private deployment input and replace its SMTP placeholders with the relay settings. The example selects authenticated SMTP on port 587 with StartTLS. Keep every `Smtp` value a string, as required by Keycloak’s realm representation. Re-run the ordinary `production.py up` command after an intentional change: startup import alone [skips an existing realm](https://www.keycloak.org/server/importExport), so the command now verifies the installation marker and both original private clients before applying registration, required email verification and SMTP settings through the private administration API. It does not recreate users/clients or rotate their secrets. Existing installations without the marker must still match both original private client credentials before they can be marked. Omitting `Identity` retains the declared default of disabled public registration and no SMTP configuration; preserve the explicit block for an enabled deployment.

The complete self-registration/browser SMTP fixture passed [clean Linux CI](VALIDATION.md#verified-real-registration-and-linux-restart-2026-10-16). Its mail receiver accepts only a reserved synthetic recipient on the owned test bridge, stores only the private verification link and never relays mail. Actual external relay credentials, inbox delivery and the operator’s DNS remain separate checks.

`Providers:Google`, `Providers:Domains`, `Providers:ReadinessEmail` and `Providers:Notifications` are passed to the existing explicitly selected adapters. An optional private `GoogleCredentialsFile` (absolute ADC credential file path) is mounted only in the provisioning worker. Configure a separate `NotificationCredentialsFile` with the tenant notification sender permissions for the commerce/admin hosts; project creation/IAM credentials are never mounted there. These private files are never baked into the image. Disabled providers do not claim a successful cloud deployment. This baseline image does not include an Android toolchain, and keeps mobile builds disabled by default. The opt-in Android worker image below packages that toolchain; its clean container release verification passed for the exact source recorded below. Azure provider selection remains supported through the shared interfaces and standalone portable configuration, while this initial generated Compose profile uses AesGcm.

The fresh Linux probe runs `production.py up` against new owned resources, enrolls two real OIDC owners through SaaS, verifies each tenant’s actual storefront and owner administration login, repeats startup and checks public tenant readiness plus preserved SaaS/admin sessions, key and runtime privileges. Synthetic DNS is supplied through an isolated CONNECT fixture, with a private CA and strict end-to-end HTTPS; it does not change the hosts file or global trust. No real DNS/Google/SMTP account is used. CI also selects the real Firefox acceptance path with `--browser`: a third owner follows the home registration button, fills the Angular form, observes the ready screen and retains the original browser session across restart. This browser path has its own [validation prerequisites and result scope](VALIDATION.md#real-angular-registration-browser-gate-2026-10-16); the complete real registration/restart path passed [exact-source CI](VALIDATION.md#verified-real-registration-and-linux-restart-2026-10-16).


## Optional Android worker

On Linux amd64, merge the `Providers:Mobile` fragment from `infra/production/android.example.json` into the existing private deployment input. Configure `Providers:Google` first as described in [GOOGLE_FIREBASE.md](GOOGLE_FIREBASE.md#enable-google-in-linux-compose). Enable `AcceptAndroidSdkLicenses` only after accepting the [Android SDK terms](https://developer.android.com/studio#command-line-tools-only). `AllowSigningKeyCreation` permits one encrypted tenant signing identity; set `SharedArtifactsConfirmed` only after arranging a consistent backup of the shared secret database, encryption key and private `mobile-artifacts` directory. All three example confirmations default to false.

The ordinary `production.py up` selects the same mobile provider in SaaS and the worker, builds a separate `<server-image>-android` image when missing, and mounts private `mobile-work`, `mobile-artifacts` and `mobile-cache` directories only in that worker. The Android image inherits the committed server runtimes and installer. It adds JDK 17, checksum-pinned Android CLI 19.0, build-tools 35.0.0, Android platforms 31/35/36 (31 is required by the existing splash plugin), NDK 28.2.13676358 and Flutter 3.44.6 at the verified repository revision. Its mobile source package comes exclusively from the committed Git snapshot and retains the existing immutable source hashes. Tenant signing keys and cloud credentials are runtime inputs and never enter this image.

Allow at least 30 GiB free before constructing the Android image and at least 15 GiB free on the worker filesystem for actual release builds, in addition to retained APK/cache storage. Use a dedicated build host with sufficient memory. Initial SDK/Gradle/pub retrieval requires internet; this is not an offline APK build. The current packaged worker supports Linux amd64. It builds an ARM64 Android APK; it does not automate iOS signing or publish to application stores.

The image can also be prepared and checked explicitly, using the current committed server image built for the same non-root operator:

```sh
python3 scripts/production_android.py build --server-image commerce-platform:local --image commerce-platform:local-android --accept-android-sdk-licenses
python3 scripts/production_android.py verify --image commerce-platform:local-android
# Full disposable signed Flutter release test, with 20 GiB free and no Google publication:
python3 scripts/production_android.py smoke --image commerce-platform:local-android
```

The dedicated `production-android.yml` CI workflow builds both real images, executes pinned tools/source verification offline as non-root, then runs the actual complete signed Flutter release inside the worker image. Synthetic signing/Firebase inputs are disposable; the fixture disables outbound Crashlytics upload tasks and never invokes App Distribution. Exact source `06bc5fcbf389a6552c04bcbdd1002bd5008b6d84` passed the actual image build, offline tools/source checks and complete signed ARM64 Flutter release in [Linux CI run 38875122833](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/runs/38875122833). Live Google projects, tester installation and crash/notification delivery remain separate acceptance gates.

Enable the mobile provider before new business registrations. Drain earlier jobs with their original worker/source profile before changing that policy; request/source/signing bindings deliberately reject a changed initial release plan. Later app upgrades are a separate workflow. Preserve the private mobile directories across restart and back up signing secrets and committed APKs together. Multiple worker nodes need the same shared artifact directory and protected secret database/key; the single-host Compose bind mount is not a multi-host storage service.
