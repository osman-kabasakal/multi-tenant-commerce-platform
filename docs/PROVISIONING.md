# Tenant onboarding implementation

The target is a cloneable, Azure-optional platform where a SaaS subscription creates a working tenant: its database, identity, domains, notifications and mobile Firebase configuration, Crashlytics and App Distribution setup. Local development must exercise the same orchestration with explicit local adapters. Deployments must select and validate their infrastructure providers.

This document tracks implementation against that full target. Local trial onboarding and the cloud-free Linux Compose/browser/cold-restore baseline passed their scoped checks. A later [real public HTTPS Oracle enrollment](validation/oracle-saas-android-20261017.json) completed the normal durable trial queue through isolated database, ordered tenant initialization, identity, Google/Firebase, domains, web publication and signed Android App Distribution upload/download. The original Android request, owner password, APK and signer survived a coordinated restart; SELECT-only Linux consumers verified the exact provider binary. These results do not complete signed iOS, device delivery, continuous tenant background processing, actual merchant acceptance or public asset rights. Current remote CI is unavailable because of the account quota. Use the status table below.

## Implemented foundation

- `Shared/Platform.Provisioning` supplies a PostgreSQL queue independent of Redis Pub/Sub and Hangfire's process memory.
- Registration can opt into the durable queue with `Provisioning:Enabled=true`. This branch does not call Mongo Atlas or publish a transient Redis registration event. The worker is responsible for database creation.
- Tenant initial passwords are inserted into the encrypted secret store before enqueueing. Repeated registration does not rotate them. Job records contain public setup metadata and secret references, never credential values.
- A unique business ID and unique slug prevent duplicate setup and conflicting ownership. A different desired request cannot silently replace an existing one.
- Workers claim jobs atomically with `FOR UPDATE SKIP LOCKED`, renew their lease and checkpoint each completed step. A crashed worker's expired lease can be reclaimed. Claim tokens fence stale checkpoint, completion and failure writes.
- Completed steps survive retries. Failed steps use bounded retry/backoff and retain a safe error code instead of provider response bodies. Explicit retry resumes failed jobs.
- Authenticated business owners can inspect `/api/Provisioning/{businessId}` and retry `/api/Provisioning/{businessId}/retry` when the feature is enabled. The application handlers independently check ownership.
- A completed payment reconciles a missing queue write on registration replay without calling the payment provider again.
- SaaS payment setup defers database metadata to asynchronous completion when durable provisioning is enabled.

`Provisioning:ConnectionString` defaults to `PlatformSecurity:ConnectionString`. Use a separate database or the security database, not the SaaS application's EF initialization database. `Provisioning:InitializeSchema=true` creates the queue schema; use a schema owner only for initialization. Runtime API writers need SELECT/INSERT plus UPDATE for authorized retries; workers need SELECT/UPDATE. Keep these backend database credentials private.

The worker accepts ordered `IProvisioningStep` implementations. Each provider must inspect/reuse resources using the canonical tenant ID. The database lease protects job state; external APIs must remain idempotent if a worker crashes after an external side effect and before a checkpoint.

## Remaining work and acceptance evidence

| Requirement | Current state and remaining work | Completion evidence |
| --- | --- | --- |
| Azure-free local and production startup | Portable AES-GCM/PostgreSQL secrets and environment configuration are implemented. Linux Compose/browser/cold-restore gates passed in their recorded CI scope; the actual public Oracle server and matching Android worker also ran without Azure credentials. Current remote CI and general release review remain open. | [Linux baseline and history](VALIDATION.md), [public Oracle Android record](validation/oracle-saas-android-20261017.json) |
| New SaaS subscription provisions a tenant | A fresh real HTTPS/OIDC trial durably selected Android and completed all eleven normal worker checkpoints. Replay preserved its trial/request. Paid activation and recovery have contracts/integration coverage; actual merchant UI/account acceptance remains. | Ordinary SaaS session recognizes completed setup; original owner password still works after restart |
| Tenant database | The real authenticated Mongo adapter creates an isolated database/account. Runtime roles and cross-tenant denial were checked in earlier Linux fixtures; existing content was preserved during installer reconciliation. Optional Atlas needs its own configured acceptance. | [Database bootstrap](DATABASE_BOOTSTRAP.md), real newly provisioned tenant in the [Android record](validation/oracle-saas-android-20261017.json) |
| Tenant identity and domains | Scoped Keycloak clients, public wildcard store/manage routing, gateway admin boundary and actual HTTPS readiness are verified. Explicit Cloudflare CNAME mode has contracts; the live Oracle run used preconfigured owned wildcard DNS. | Actual public storefront and native owner admin login after restart; no fixed tenant-list edit |
| Ordered tenant initialization | All standard plugins compile for every BuildType; all AdminPlugins compile outside Frontend. Portable runs plugin install, migrations and the 168 original business settings in order; TRY, mobile address fields and 1/10/20 tax defaults are verified in both fresh setup and reconciliation. The legacy Keycloak lifecycle stays inactive. | [Tenant initialization](TENANT_INITIALIZATION.md), [live initialization record](validation/oracle-tenant-initialization-20261017.json), fresh Android job |
| Notifications | Tenant Firebase and the separate limited FCM sender are provisioned; commerce consent/registration/routing and direct APNs code are implemented. Identity email was human-confirmed. Readiness email has its own durable SMTP outbox; actual device FCM/APNs/tap/image behavior, browser push and real external store-mail delivery remain. Store queued-message execution passed with a private SMTP sink. | [Notifications](NOTIFICATIONS.md), [readiness email](READINESS_EMAIL.md), recorded provider contracts and live configuration |
| Google/Firebase per business | The operator-selected organization and separate sender are configured and real per-tenant creation now works. Human organization-admin Owner access, Firebase apps/SDK files, groups and encrypted distributed readers passed their scoped live checks. Device sending/reporting remains separate. | [Google setup](GOOGLE_FIREBASE.md), actual fresh SaaS Google checkpoint and native Firebase resource verification |
| Flutter Crashlytics and App Distribution | The ordinary fresh Android queue built the actual signed APK and uploaded it to live App Distribution; a separate read-only consumer verified native Firebase/Crashlytics resources and exact provider download before/after restart. Positive signed iOS, exact-release device startup, actual crash reports and notifications remain. | [Latest Android record](validation/oracle-saas-android-20261017.json); earlier synthetic release CI remains separate |
| Continuous tenant background work | The separate opt-in Portable host now validates owned completed tenants and executes sequential leased tasks. Thirteen real-Mongo checks and actual core queued-mail/clear-cache execution with a private SMTP sink passed; host restart preserved intervals and prevented redelivery. Shared Redis SignalR passed 13 real WebSocket/process checks and a full clean Backend native-login/cookie acceptance. Portable new-order/cache consumers and configured integration acceptance remain. | [Task setup and boundaries](TENANT_BACKGROUND_TASKS.md), [scoped Linux acceptance](validation/oracle-tenant-schedules-20261017.json); normal production scheduling remains disabled; [distributed notification transport](DISTRIBUTED_NOTIFICATIONS.md) |
| Deployment and recovery | Non-root Linux Compose and public minimal Oracle deployment worked; actual fresh Android publication, coordinated state/key/artifact/data backup and private off-host checksum verification passed. The new Oracle snapshot has not been restored into an empty destination; previous full cold restore belongs to its earlier isolated Linux fixture. | [Linux](LINUX_PRODUCTION.md), [Oracle operator guide](ORACLE_SSH_DOCKER_DEPLOYMENT.md), scoped validation records |
| Public-source release | Current repository is private. Tracked-source/secret guards and asset inventory passed; unresolved asset provenance and inherited dependency review still prevent a general public-release claim. | [License review](LICENSE_REVIEW.md), [validation history](VALIDATION.md) |

## Current verification

```sh
# Requires this checkout's demo PostgreSQL, or an ignored config with a reachable test admin.
dotnet run --project tests/Provisioning.Integration/Provisioning.Integration.csproj -c Release -- .local/saas.json
(cd SaasManager && dotnet test ../tests/Registration.Security.Tests/Registration.Security.Tests.csproj -c Release)
(cd SaasManager && dotnet run --project ../tests/Payments.Integration/Payments.Integration.csproj -c Release -- ../.local/saas.json)
```

Paid setup configuration and its remaining merchant/reconciliation gates are documented in [PAYMENTS.md](PAYMENTS.md).

The provisioning test creates and drops only a uniquely named `provisioning_test_*` database. It verifies concurrent initialization/enqueue/claim, independent-process checkpoint access, slug/request conflicts, crash recovery, stale-worker rejection, safe errors and step-level retry. That low-level test does not provision a real store or cloud resources. `python3 scripts/smoke_onboarding.py` separately creates two real local stores via authenticated SaaS HTTP requests and checks the complete local path.

Provider implementation references: [Firebase project/app management](https://firebase.google.com/docs/projects/api/workflow_set-up-and-manage-project), [Flutter Crashlytics setup](https://firebase.google.com/docs/crashlytics/flutter/get-started), [App Distribution REST API](https://firebase.google.com/docs/reference/app-distribution/rest/).

## Portable encryption and configuration

`PlatformSecurity:Provider=AesGcm` explicitly selects the production-capable portable adapter. Supply `PlatformSecurity:AesGcm:MasterKeyBase64` or `MasterKeyFile` through deployment secrets and share exactly the same key between all service instances. The Local provider remains restricted to Development plus `LocalDemo:Enabled`.

The portable adapter uses the **existing** AES-GCM engine and `psec:local:v1:` wire format for compatibility. No ciphertext is rewritten and no key is generated or rotated. Selecting it with the same master key can read the existing encrypted store, verified against independently constructed AES ciphertext and a real PostgreSQL store. Switching from Azure encryption still requires an explicit data migration; this work performs none.

Commerce configuration can use `PlatformConfiguration:Provider=Environment` and optional `PlatformConfiguration:ConfigPath`. Common defaults load first, then explicit file/environment values; mandatory Mongo/Redis values must be supplied. This path does not instantiate a Key Vault client. `AzureKeyVault` remains available explicitly or through an existing `ConnectionStrings:kvUri`. The Azure Web Apps flag now defaults to false.

SaaS can explicitly select the shared card protector and either private filesystem or Azure file storage; see [SAAS_PROVIDERS.md](SAAS_PROVIDERS.md). Portable encryption and successful builds alone do not establish a complete Azure-free production deployment.


## Running local enrollment

1. Run `python3 scripts/demo.py up`. It starts the headless worker alongside the web hosts; no Azure, Firebase or paid database account is required.
2. Open `http://localhost:18081/local-onboarding.html` and sign in with `demo-owner` / the `saas_user` password from ignored `.local/credentials.json`. A separate verified Keycloak account is needed for each additional business, matching the existing one-business-per-owner domain model.
3. Choose a unique business name (its normalized slug must be a lowercase DNS label of 3-40 characters) and a 12-128 character store-admin password. The handler persists one zero-amount trial subscription and one mobile application record, then queues setup. It never resolves or invokes the card/payment provider.
4. The worker creates a database/user scoped to the business ID, runs the installer in an isolated working directory, creates an owned Keycloak client and publishes a local route. New storefront and admin hosts become available without host restarts. Use the account email plus your chosen store-admin password for the separate GrandNode admin login.
5. `.local/notifications/<slug>/ready.json` is the local notification sink. `.local/mobile/<slug>.json` contains public tenant configuration with Firebase explicitly disabled. Generate Flutter debug defines with `python3 scripts/mobile_tenant.py <slug>`; see [MOBILE.md](MOBILE.md).

Mongo authentication is enabled for both sample and newly provisioned tenants. Reusing an older unauthenticated demo volume initializes its first administrator through Mongo's localhost exception. Existing users/passwords are not silently reset. The admin host validates the configured seeded database and does not install a default account at startup.

The local provider requires Development plus `LocalDemo:Enabled`; Google is Disabled by default and can be explicitly enabled as described in [GOOGLE_FIREBASE.md](GOOGLE_FIREBASE.md). It is not a fake successful Google/Firebase deployment. Local secrets, installer output and logs remain under ignored `.local`. Startup validates the installer and its published logo before consuming jobs. Installer diagnostics are bounded and mask the administrator password and full database connection.

Provider-level checkpoints survive retries. The inherited GrandNode data seed itself is not transactional; a failure halfway through its initial seed can require operator repair of that unpublished tenant. The worker does not delete live tenant databases or silently declare a partial install ready. Completed installer output is validated against tenant ownership before being reused.

## Verification of local onboarding

```sh
python3 scripts/demo.py up
python3 scripts/smoke_onboarding.py --fresh
python3 scripts/demo.py smoke
```

The fresh test uses two new verified Keycloak users and two new trial businesses. It checks real OIDC login, antiforgery, unique enrollment/replay, every worker checkpoint, live storefront/product/API access, actual admin login, SaaS trial/database completion, mobile guest/catalog tokens, public Flutter defines, local notifications, owner-only job access, cross-tenant token/cookie denial, Mongo user isolation and absence of passwords in application logs. Its synthetic accounts and generated credentials stay in an ignored fixture file. Cloud resources are not created.

## Optional Google/Firebase provider

See [GOOGLE_FIREBASE.md](GOOGLE_FIREBASE.md) for configuration, IAM boundaries, ADC, resource reconciliation, client export and App Distribution commands. The Google step runs before tenant publication when explicitly selected. Default cloud-free onboarding retains its five original steps. Commerce sends through the shared tenant sender without a process-global Firebase app; the real local storefront/admin consent flow is verified. See [NOTIFICATIONS.md](NOTIFICATIONS.md) for runtime configuration and remaining delivery gates. The supplied operator account has passed live read-only project/Firebase/API access checks; per-tenant cloud creation and device delivery remain unverified. See the Google guide for the remaining target/API checks.

See [PORTABLE_PROVISIONING.md](PORTABLE_PROVISIONING.md) for the Portable profile, scoped Keycloak account, domain providers, ownership fencing and public runtime readiness requirements.

The Portable runtime probe and gateway boundary are documented in [GATEWAY.md](GATEWAY.md). Customer token login routes now require the ordinary password verifier and reject inactive/deleted/locked or two-factor-pending accounts before creating a session; both current tenant and legacy token routes are covered by production-source tests. Full mobile/account and payment workflows still need their separate acceptance checks.

The initial PostgreSQL/SaaS installation now has a separate [owner bootstrap and runtime verification workflow](DATABASE_BOOTSTRAP.md). This is one part of fresh deployment; it does not create PostgreSQL servers, identity realms, MongoDB, TLS or ingress.

The generated single-host deployment now has a separate [cold snapshot/restore command and successful real Linux restoration gate](BACKUP_RESTORE.md). It does not replace configured cloud/device verification.
