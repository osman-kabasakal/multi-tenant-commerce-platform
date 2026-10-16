# Optional Azure providers in SaaS Manager

SaaS configuration can select `PlatformConfiguration:Provider=Environment`. An optional `PlatformConfiguration:ConfigPath` loads a private JSON file, with environment variables applied afterwards. Explicit Environment selection does not load Key Vault even when `AZURE_KEY_VAULT_ENDPOINT` is populated. `AzureKeyVault` requires an explicitly configured endpoint. Keep connection strings and keys in deployment secrets, outside Git.

## Card protection

`CardProtection:Provider` defaults to `Disabled`. Explicit `Platform` selection uses the existing shared `ITenantEncryptionService`, with `PlatformSecurity:Provider=AesGcm` or `Azure` as documented in [TENANT_SECURITY.md](TENANT_SECURITY.md). All instances need the same existing encryption configuration and master key. The Local encryption provider remains restricted to the local development demo.

The new `pcard:v1:` envelope binds card details to the verified registration business. It persists PAN, expiry and holder, plus masked display metadata; CVV is excluded and decrypts as an empty string. This is a new opt-in format. No existing card ciphertext or keys are rewritten or rotated. Legacy envelopes are rejected by this provider and require their original reader and a separately planned migration. The old Azure card implementation remains in the source but is no longer selected by the host. Live payments and legacy card decryption have not been verified. Local trial onboarding continues with card processing disabled.

## Private file storage

Choose `FileStorage:Provider=FileSystem` with an absolute `FileStorage:FileSystem:RootDirectory` outside `wwwroot`. The demo generates `.local/files`. Independent replicas must mount the same private persistent volume at this path; per-replica ephemeral disks are insufficient. Back up the volume together with database references. Files use opaque `pfile:v1:` references, private permissions, bounded streaming and atomic replacement. Existing Azure references are not automatically migrated or reinterpreted. File writes and database changes are not one transaction; failed database saves can leave orphaned files.

Choose `FileStorage:Provider=Azure` with `FileStorage:Azure:ConnectionString`, or an HTTPS `FileStorage:Azure:Endpoint` with managed identity credentials. The legacy `AZURE_STORAGEBLOB_CONNECTIONSTRING` environment setting remains supported. The same configured account handles upload, read and deletion. New references omit SAS query strings; downloads reject foreign accounts and references containing query strings or fragments. Existing SAS references therefore need a deliberate migration. `Disabled` is the default when no provider is selected.

Uploads require an authenticated verified business owner, that owner's application, a supported image signature and antiforgery protection. Private asset and build downloads check ownership before opening storage and stream responses with private/no-store headers. These are application endpoints, not public file URLs. The demo enables only the specific file routes through `LocalDemo:AssetsEnabled`; cloud build and billing mutations remain disabled.

## Verification and remaining gates

Run the .NET 9 tests from the SaaS directory so its SDK selection applies:

```sh
cd SaasManager
dotnet test ../tests/Portable.Services.Tests/Portable.Services.Tests.csproj -c Release --nologo
```

Provider and hosting tests cover the real card provider and existing encryption engine, cross-business/master-key/tamper denial, CVV exclusion, filesystem traversal/symlink/size/cancellation handling, independent-instance reads, handler ownership, and Azure SDK CRUD through an HTTP test transport. No real payment or Azure resources are used. The SaaS Web Release build passes with inherited compiler warnings. Live file HTTP checks and a Production-mode SaaS HTTPS/OIDC probe are provided below. Complete portable production startup, deployment, and remote CI for this snapshot remain separate gates; see [PROVISIONING.md](PROVISIONING.md).

## Portable SaaS hosting

Set `ApplicationUrl` to the public HTTPS origin. `Web:AllowedOrigins` optionally supplies exact additional browser origins, without paths, wildcards or trailing slashes. Production CORS configuration no longer depends on the internal `ASPNETCORE_URLS` listen address. Set the secret through `AuthConfiguration__ClientSecret` or a private `AuthConfiguration:ClientSecret` setting; the legacy `ClientSecret-{clientId}` setting is still accepted when the hierarchical setting is absent. The identity authority, confidential client id and secret are validated at startup; HTTP identity metadata is permitted only in the Development local demo.

For several SaaS replicas, set an absolute private `Web:DataProtectionKeyDirectory` and stable `Web:DataProtectionApplicationName` shared by those replicas. This is opt-in and does not move existing cookie keys. Choosing a new key ring/application name invalidates existing sessions. Persist and back up the private volume; filesystem permissions do not encrypt keys at rest. Apply volume/backup encryption or an appropriate key-at-rest provider for your deployment. [ASP.NET Core key persistence guidance](https://learn.microsoft.com/en-us/aspnet/core/security/data-protection/configuration/overview?view=aspnetcore-9.0).

Publicly trusted HTTPS identity servers need no custom certificate configuration. Private-PKI deployments may explicitly set `AuthConfiguration:AuthorityRootCertificateFile` to an absolute PEM/DER CA certificate file mounted read-only. Trust is scoped to the OIDC and bearer identity backchannels. The ordinary TLS hostname, validity and chain-signature checks remain enabled; no global trust store or certificate validation callback is changed. The transport retains the normal HTTP revocation setting and does not fetch missing intermediate certificates, so the server must present its chain. [TLS chain policy](https://learn.microsoft.com/en-us/dotnet/api/system.net.security.sslclientauthenticationoptions.certificatechainpolicy?view=net-9.0).

`AuthConfiguration:Scopes` can explicitly request issuer-configured scopes; defaults are `openid`, `profile`, `email`, `roles`. Include `openid`. Add `offline_access` or a custom store scope only when needed and configured at the issuer. Protected state and correlation validation use the ASP.NET Core defaults; signature, issuer, audience, expiry and nonce checks remain enabled. [Framework state handling](https://github.com/dotnet/aspnetcore/blob/v9.0.11/src/Security/Authentication/OpenIdConnect/src/OpenIdConnectOptions.cs).

Raw SQL diagnostics are never mapped outside Development. In Development they are disabled by default and require `Diagnostics:DatabaseQueries:Enabled`, an explicit private key of at least 32 characters, the administrator policy, and antiforgery validation for writes. There is no default diagnostic key. The API document at `/api/specification.json` is now generated from actual mapped endpoints; the obsolete static snapshot has been removed.

## Repeatable HTTP checks

After `python3 scripts/demo.py up` and `python3 scripts/smoke_onboarding.py`:

```sh
python3 scripts/smoke_storage.py
python3 scripts/smoke_portable_saas.py
python3 scripts/demo.py smoke
python3 scripts/demo.py stop
```

Storage checks use the two synthetic onboarding accounts and exercise multipart antiforgery, image validation, private response headers, owner/foreign/anonymous access, and HTTP ranges. An independent .NET process creates a clearly marked synthetic transport fixture. Its `.apk` extension does not make those bytes an actual mobile build or proof of signing.

The portable SaaS probe uses this demo's loopback databases, the existing shared master key, private filesystem storage and a private cookie key ring. It launches SaaS with `LocalDemo` disabled and `Production`, and an isolated HTTPS Keycloak with an ephemeral volume. It does not reuse or alter the ordinary demo Keycloak volume. Generated certificates and test data remain in ignored `.local`; the temporary identity container/volume and Production host are removed when the probe exits. Ports `18084` and `18443`, Docker and OpenSSL are required. This verifies the SaaS host only; it is not a complete production deployment of commerce, the installer and provisioning worker.

The [SaaS component example](../infra/portable/saas.example.json) intentionally contains no credentials. Copy it outside Git and supply `ConnectionStrings__SaasManagerDb`, `PlatformSecurity__ConnectionString`, `redispublisher`, `GuestAuth__Issuer`, `GuestAuth__Audience`, `GuestAuth__SecretKey`, and `AuthConfiguration__ClientSecret` through private deployment configuration. Provide an existing shared 32-byte base64 master key at the configured file path, durable private file/cookie volumes, and an HTTPS Kestrel endpoint/certificate or a separately configured trusted reverse proxy. Set `PlatformConfiguration__ConfigPath` to that private configuration and `DOTNET_ENVIRONMENT=Production`. Supply the public Keycloak client redirect URI `https://portal.example.test/remote-auth/signin-oidc` and corresponding origin. Private CA trust is optional.

This component example does not create PostgreSQL/Redis/Keycloak or a production worker. Use the separate [owner database bootstrap](DATABASE_BOOTSTRAP.md) for fresh security/queue schemas, SaaS migrations and the explicit trial plan. The example selects `DatabaseBootstrap:Mode=External`; runtime startup verifies ownership and migrations without DDL or seeding. Supply runtime accounts without schema privileges and keep `InitializeSchema=false`. Existing migrated deployments may explicitly select `Existing` verification mode. Real payment-provider setup and end-to-end paid subscriptions remain unverified; the example keeps card processing disabled. A complete platform deployment profile remains tracked in [PROVISIONING.md](PROVISIONING.md).


## Publish the complete SaaS web host

Use .NET SDK 9 and Node.js 22/npm on the build machine. A normal publish now restores the locked Angular dependencies with `npm ci`, builds the Production frontend, and includes its index, entry assets and lazy chunks under `wwwroot` alongside the .NET web host:

```sh
(cd SaasManager && dotnet publish src/Web/Web.csproj -c Release -o ../.local/production/saas -p:UseAppHost=false)
```

Run the resulting `SaasManager.Web.dll` from that directory with the private Production configuration described above. No Node/npm process is required on the running server. Publish into a new versioned directory and switch the service to it after validation; do not overwrite a running application's files. This command builds an application artifact; it does not create the infrastructure, database schema, identity clients, DNS or certificates. Follow the owner bootstrap and provider runbooks for those prerequisites.

Only the local demo explicitly sets `BuildSaasFrontend=false`, because it supplies its separate demo frontend afterwards. A publish without the Production frontend must not be treated as a complete deployment package. The Production enrollment probe uses a new isolated normal publish directory and verifies that `/register` and its compiled JavaScript/styles are actually served over HTTPS before exercising enrollment. It still does not execute the entire Angular form in a browser.
