# Portable tenant provisioning

`TenantManager --provisioning-worker` now supports an explicit `Provisioning:Profile=Portable` alongside the unchanged Development-only Local profile. Portable runs the real GrandNode installer in the deployment environment, uses authenticated MongoDB and a scoped Keycloak service account, and supports configured Google/Firebase plus explicit domain providers. Azure encryption remains selectable through `PlatformSecurity`; a portable deployment does not require Azure credentials.

This is an implemented provisioning foundation. It is **not yet a complete production deployment**: the complete Linux Compose rollout, paid enrollment, iOS and live public cloud/device verification remain. The complete Android signed-release path and the [Linux server image](LINUX_PRODUCTION.md) have passed their separate clean CI checks. The worker deliberately fails its publication step until the public store and owned admin login actually work. Creating databases/clients alone never marks the SaaS business ready.

## Configuration

Copy [worker.example.json](../infra/portable/worker.example.json) outside Git and set `Provisioning__ConfigPath` to that private file. Supply `PlatformSecurity__ConnectionString`, `Provisioning__Portable__MongoAdminConnection`, and `Provisioning__Portable__KeycloakAdminClientSecret` through private configuration. Use the separate [owner database bootstrap](DATABASE_BOOTSTRAP.md) for the security/queue schemas, SaaS migrations and explicit public trial plan before starting runtime hosts; runtime configuration retains `InitializeSchema=false`. All processes must use the same existing shared encryption master key and secret database. No key or ciphertext migration is performed.

Publish the installer to the configured path using the ordinary Release publish command. Its project now packages `wwwroot/logo.png`, both installation translation XML files, default language resources and supported collations directly; no demo helper copy is needed. `Ecommerce/Directory.Build.targets` excludes runtime `App_Data/**/Settings.cfg`, private appsettings JSON and nested DataProtection keys from commerce/admin/installer artifacts while retaining public resources. Mount each deployment's private configuration and keys separately. The managed installer config must explicitly select `PlatformConfiguration:Provider=Environment` or `AzureKeyVault`, `PlatformSecurity:Provider=AesGcm` or `Azure`, and `LocalDemo:Enabled=false`, plus Mongo/Redis/security settings. The installer receives the tenant's private connection/password in memory and writes owned public result metadata; production client secrets remain in the shared encrypted store. Intermediate installer state and diagnostics belong in private working directories, never in source control. Initial seeding is still inherited/nontransactional and a partial seed can require operator repair.

Configure absolute private directories for work, installation results, routes, mobile client files and readiness outbox events. Portable validation rejects symbolic-link directories and makes private roots owner-accessible only. Runtime nodes must mount the same route/mobile directories; the [readiness SMTP sender](READINESS_EMAIL.md) can run automatically in the worker or as a separate minimal-privilege process. Delivery uses the post-success PostgreSQL outbox; writing a diagnostic ready file alone does not send email or a device notification.

A tenant is bound to its deployment id, database target, identity realm, domain configuration and publication paths before steps run. The guard checks this binding on every attempt, including attempts where every step already has a checkpoint. Changing a target is an explicit migration, not a silent resource move. Missing original bindings on a partially completed job are refused. Administrative credential values are excluded from this binding.

## Configured Production trial enrollment

The existing SaaS `/register` page can enroll verified identity owners with their actual company/contact information and chosen store-admin password. Enable `TenantOnboarding:Trial:Enabled` only in Production or Staging with `LocalDemo:Enabled=false`. Run the owner database bootstrap for a fresh installation, then select its existing active, public subscription plan with positive `TrialDays` using `TenantOnboarding:Trial:PlanId`; the example leaves enrollment disabled until that plan is selected. No card/payment provider is invoked for this explicitly configured zero-amount trial. This path does not implement paid subscription activation.

SaaS must select `Provisioning:Enabled=true`, `Provisioning:Profile=Portable`, a writable shared secret store and `Provisioning:DeploymentId` equal to the worker's `Provisioning:Portable:DeploymentId`. Run compatible versions of SaaS and workers together: new requests carry this deployment binding, and updated Portable/Local guards reject requests assigned to another deployment before resource writes. Legacy unbound queue requests remain compatible.

`/api/TrialBusinesses/configuration` requires a verified owner and returns the selected plan, form, owned business state and an antiforgery token. POST `/api/TrialBusinesses` requires that token in `X-XSRF-TOKEN`. A stable registration GUID supports retry after queue failure without another business, app, trial extension or payment. Replays cannot change company details or adopt another owner's registration. Passwords are saved through the common encrypted tenant-secret path; job status never includes them. Only verified worker publication and reconciled database readiness complete the ordinary SaaS session.

To exercise the actual Production hosts with two fresh owners and isolated PostgreSQL/Mongo/HTTPS identity resources:

```sh
python3 scripts/demo.py up
python3 scripts/smoke_portable_deployment.py --saas-enrollment
python3 scripts/demo.py stop
```

This probe covers real SaaS HTTP enrollment, worker resource creation, public HTTPS storefront/admin login, replay and cross-owner/tenant isolation. It uses synthetic DNS and private fixture certificates, and does not deploy external infrastructure. Angular production compilation and interceptor browser tests are separate checks; full `/register` browser form interaction is still pending.

## Keycloak service account

Create a confidential `tenant-provisioner` client in the configured management realm, enable service accounts and disable interactive login. Assign its service account the target realm-management permissions required to create/query/view/manage clients (`create-client`, `query-clients`, `view-clients`, `manage-clients` for the tested Keycloak 26.8.0 setup). Limit it to the intended realm. The Portable profile uses client credentials, not the master administrator's password. [Keycloak service accounts and realm administration](https://www.keycloak.org/docs/26.8.0/server_admin/).

Every created tenant client carries the canonical business id. A replay inspects its private policy, saved secret, encrypted store/database mappers and audience; drift is rejected without resetting the client secret or rewriting encrypted claims. Unowned clients are never adopted. The shared `Platform.Security.PrivateCertificateAuthority` helper can scope explicit private CA trust to the identity/ingress clients through `IdentityRootCertificateFile` / `IngressRootCertificateFile`; TLS name and chain verification remain enabled. Commerce can select the same CA using `AuthConfiguration:AuthorityRootCertificateFile`.

## Domain providers

`Provisioning:Domains:Provider=Wildcard` requires `WildcardConfigured=true` only after the operator configures both parent-domain wildcard DNS records and an ingress that serves the routes. No DNS API call is claimed for this provider. The checked-in example deliberately leaves confirmation false. Tenant names are always derived from the validated slug and the configured HTTPS store/admin parent domains.

Alternatively configure `Provider=Cloudflare`, `AllowCloudWrites=true`, `ZoneId`, `ZoneName`, a zone-scoped private `ApiToken`, and `TargetHost` for the ingress. The token needs zone inspection plus DNS editing for that zone. Both domain parents must lie inside the configured zone. The adapter creates CNAMEs for the store/admin, labelled with the deployment id and canonical tenant id. Existing foreign records, record conflicts, changed targets and changed proxy policies are refused. Replays preserve already-correct records; no deletion or automatic target/ownership overwrite is performed. `Proxied` defaults to false so TLS is served by the configured ingress. [Cloudflare record creation API](https://developers.cloudflare.com/api/resources/dns/subresources/records/methods/create/).

## Runtime readiness and routing

Enable `Provisioning:ReadinessEndpoint=true` on commerce. `/_platform/ready` stays behind ordinary tenant JWT verification, reads the actual selected store database, verifies canonical secret aliases and returns only tenant/store ids with no-store caching. A direct request without a valid tenant token is rejected. The production public gateway must fetch/inject the tenant token itself; the worker sends its readiness probe as an ordinary public caller without a privileged token.

On the admin host select `TenantRouting:Provider=Directory`, `TenantRouting:RouteDirectory` and `TenantRouting:AdminParentDomains` containing the exact admin parent domains. Only versioned, owned Portable manifests are accepted. The router checks both slug/store aliases against the shared secret store, selects the tenant's private connection per request and adds `X-Platform-Tenant`; it does not authenticate the visitor. Unknown hosts, wrong ports and foreign bindings are rejected. The worker requires the owned HTTPS admin redirect and a same-origin HTML login page before completion. General HTTP proxy/TLS configuration remains a deployment gate; do not trust arbitrary forwarded headers.

Routes can appear after database/identity/domain setup so that the ingress can serve the readiness probe. The job, ready outbox and mobile manifest remain incomplete if that probe fails. Firebase client files are published only after successful runtime readiness and validated tenant Firebase ownership. Client files contain no service-account private key or central sender identity. Real FCM/device delivery and full mobile distribution still require their separate configuration and verification.

GrandNode's **Stores** settings define the store domain/SSL URL; the managed installer receives the explicit HTTPS tenant origin. Tenant-specific dependencies use the existing request context and DI, following GrandNode's [Stores](https://docs.grandnode.com/stores) and [Dependency injection](https://docs.grandnode.com/dependency-injection) guidance.

## Production gateway

The .NET/YARP gateway now serves owned Portable routes, obtains confidential tenant tokens on the server and preserves customer bearer authentication. Commerce, admin and SaaS share explicit proxy trust configuration instead of the old raw forwarded-scheme overrides. See [GATEWAY.md](GATEWAY.md) for private-hop/TLS boundaries, component examples, startup and the real Production-mode probe. Public synthetic HTTPS tenant runtime verification remains distinct from a real DNS/infrastructure rollout.

## Verification

```sh
dotnet test tests/Portable.Provisioning.Tests/Portable.Provisioning.Tests.csproj -c Release
python3 scripts/smoke_publish_boundaries.py
python3 scripts/demo.py up
python3 scripts/smoke_readiness.py
python3 scripts/smoke_portable_worker.py
python3 scripts/demo.py stop
```

The resource probe uses real local PostgreSQL/MongoDB, the published Production installer and an isolated HTTPS Keycloak with a scoped service account. It verifies actual resource creation, identity replay, no demo products, database isolation, deployment fencing and refusal to mark ready without a public ingress. Its unique PostgreSQL/Mongo namespaces are removed; ordinary demo data and identity volumes are preserved. Contract tests cover Cloudflare ownership/idempotence and positive/negative readiness responses through HTTP test transports; no real Cloudflare account or public deployment has been exercised. See [VALIDATION.md](VALIDATION.md) for the recorded results and [PROVISIONING.md](PROVISIONING.md) for the full remaining target.


## Start a deployment before its first tenant exists

The Directory admin host starts with no published tenant routes. Only TenantManager's explicit installer may create a new store and its chosen owner account. Administration startup does not create an example store or a fixed administrator. A standalone non-demo admin host must instead point at a database already prepared by the explicit installer.

The inherited commerce engine still requires a configured `Database:ConnectionString` during service registration. For the shared runtime hosts, provision a separate **unseeded MongoDB namespace with a user having only the `read` role on that namespace**, and supply that private connection as the startup context. It needs no GrandNode installation, store, products or administrator account. Keep its credentials separate from the worker's Mongo provisioning account. Select `Application:DisableHostedService=true` and `Application:SkipMigrationProcess=true` on commerce/admin, as the examples do; per-tenant installation and migration belong to the explicit worker workflow.

The gateway requires an owned published route and the commerce host verifies its tenant token. The Directory admin middleware resolves the owned route before selecting the tenant connection from the shared secret store. These boundaries remain required. Requests for unknown hosts are refused. The runtime context provides no tenant fallback, and new business data is written only into its provisioned tenant database.

`smoke_portable_deployment.py --saas-enrollment` now starts the real Production hosts against a unique empty read-only context, checks emptiness before the worker is allowed to provision, creates two tenants through ordinary SaaS enrollment, verifies their actual storefront/admin login, and checks that the context remains empty afterwards. The synthetic fixture owns and removes that context's user/namespace; it does not grant the runtime a Mongo administrator account. This strengthens the no-existing-tenant startup evidence but does not provision a public DNS zone or the rest of a real hosting environment.

The publish-boundary probe runs three ordinary .NET publishes with disposable synthetic private files and a legitimate public resource. It verifies private content is absent from each artifact and all four required installer resources exactly match their tracked originals. It removes its source probes and output directories. The Production enrollment probe also publishes its own fresh installer and actually runs that package during tenant creation.
