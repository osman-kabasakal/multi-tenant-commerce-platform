# Fresh Production database bootstrap

The web application no longer applies Production migrations or invents default plans/payment providers at startup. A separate owner command prepares explicitly named, already-created PostgreSQL databases. Runtime replicas verify readiness using accounts without schema privileges. This works with the existing `AesGcm` provider and shared deployment key; Azure remains selectable. No existing key or ciphertext is migrated or rotated.

This command initializes the shared encrypted store, durable queue protocol, actual SaaS EF migrations and one operator-selected public trial plan. It does not create PostgreSQL servers/databases/roles, MongoDB, Keycloak realms, public DNS, TLS or ingress. Those infrastructure and deployment steps remain separate gates in [PROVISIONING.md](PROVISIONING.md).

## 1. Create empty databases and an owner

Use your PostgreSQL administrator to create an ordinary login owner and explicitly named databases. For example, in an interactive `psql` session:

```sql
CREATE ROLE commerce_owner LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
\password commerce_owner
CREATE DATABASE commerce_security OWNER commerce_owner;
CREATE DATABASE commerce_saas OWNER commerce_owner;
```

The queue may share `commerce_security`. To separate it, create a third empty database owned by the same owner and configure `Provisioning:ConnectionString`. SaaS must have its own database name. System databases and custom connection-string search paths are rejected. An existing application database is not silently adopted; restore the original ownership records or perform an explicit reviewed migration for older installations.

## 2. Supply private configuration

Copy [bootstrap.example.json](../infra/portable/bootstrap.example.json) to `.local/production/bootstrap.json` or another private directory. Keep the file and any key owner-readable only. Set these required values in that file or through environment variables:

| Setting | Value |
| --- | --- |
| `PlatformSecurity:ConnectionString` | Owner connection to the explicitly named security database |
| `ConnectionStrings:SaasManagerDb` | Owner connection to the separate SaaS database |
| `Provisioning:ConnectionString` | Optional owner queue connection; defaults to the security database |
| `PlatformSecurity:Provider` | `AesGcm`, or the separately configured `Azure` provider |
| `PlatformSecurity:AesGcm:MasterKeyFile` | Absolute path to this deployment's existing private base64-encoded 32-byte key |
| `Bootstrap:DeploymentId` | The same id as SaaS `Provisioning:DeploymentId` and worker `Provisioning:Portable:DeploymentId` |
| `Bootstrap:AllowSchemaChanges` | Explicitly set `true` only for owner initialization |
| `Bootstrap:TrialPlan` | Your stable GUID, name, unique code, price, trial days, limits and public feature strings |

Environment names replace `:` with `__`, for example `ConnectionStrings__SaasManagerDb`. Supply actual passwords from your deployment secret manager; do not put them in Git, command arguments or job output. The example intentionally omits database credentials and leaves schema authorization false. For Azure, supply the existing vault/key configuration described in [TENANT_SECURITY.md](TENANT_SECURITY.md).

For a completely new empty deployment, create one random 32-byte master key in your secret manager and supply the same value to every participating service. Preserve it in backups. For an existing deployment, use its original key; generating a replacement does not recover existing secrets. The bootstrap refuses to replace an incompatible encrypted probe.

Plan names are at most 50 characters; codes are 3–20 uppercase letters/digits/underscores starting with a letter. Price has at most two decimal places. Trial days are 1–365, and resource limits are positive or `-1` for unlimited. The configured plan is active/public, with zero setup fee and no POS/courier enablement. It is an explicit initial trial plan, not a configured payment provider or evidence of paid subscription processing.

## 3. Build and run the owner command

From the checkout root with the repository's .NET 9 SDK installed:

```sh
mkdir -p .local/production
(cd SaasManager && dotnet publish ../tools/Platform.Bootstrap/Platform.Bootstrap.csproj -c Release -o ../.local/production/bootstrap-tool)
DOTNET_ENVIRONMENT=Production dotnet .local/production/bootstrap-tool/Platform.Bootstrap.dll initialize --config "$(pwd)/.local/production/bootstrap.json"
DOTNET_ENVIRONMENT=Production dotnet .local/production/bootstrap-tool/Platform.Bootstrap.dll verify --config "$(pwd)/.local/production/bootstrap.json"
```

The CLI accepts Production or Staging. Only `initialize` changes schemas. `verify` forces read-only secret-store behavior and performs no DDL or seeding; it can use separately granted runtime credentials. Success output contains only deployment/public plan ids. Failure output contains a safe exception category and PostgreSQL SQLSTATE when applicable, never a connection string or provider response.

Owner processes serialize initialization with bounded advisory locks. Separate SaaS and queue ownership markers plus an encrypted shared fingerprint bind deployment, provider, named database targets and initial plan policy. Administrative username/password values are excluded so changing credentials does not rebind a deployment. An interrupted initialization with its original markers can resume. Replays preserve ciphertext, timestamps and tenant data. Changed targets, plan-policy drift, missing original ownership records or missing durable queue/tenant tables, SaaS migration history, initial plan or encryption probe fail instead of being reseeded or recreated. Restore a consistent database/key backup for data loss; this bootstrap is not a recovery or resource migration tool.

Keep this original configuration as installation evidence. Changing the initial plan requires deliberate plan management; rerunning bootstrap does not overwrite a later operator edit. Existing migrated deployments can select `DatabaseBootstrap:Mode=Existing` for read-only migration verification without new bootstrap markers. That mode does not adopt them into the new owner workflow or migrate them automatically.

## 4. Grant runtime privileges and start the services

Create separate backend login accounts interactively and keep the owner credentials out of runtime hosts. The following illustrates SaaS privileges after initialization; adapt the login names and databases to your deployment:

```sql
-- As PostgreSQL administrator, then set a private password interactively.
CREATE ROLE commerce_saas LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
\password commerce_saas

-- Connected to commerce_saas as commerce_owner:
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public, platform_bootstrap TO commerce_saas;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO commerce_saas;
REVOKE INSERT, UPDATE, DELETE ON public."__EFMigrationsHistory" FROM commerce_saas;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO commerce_saas;
GRANT SELECT ON platform_bootstrap.saas_state TO commerce_saas;

-- Connected to commerce_security as commerce_owner (queue shared here):
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA platform_security, platform_provisioning, platform_bootstrap TO commerce_saas;
GRANT SELECT, INSERT, UPDATE ON platform_security.secrets, platform_security.tenants, platform_security.aliases TO commerce_saas;
GRANT SELECT, INSERT, UPDATE ON platform_provisioning.jobs TO commerce_saas;
GRANT USAGE ON SEQUENCE platform_provisioning.jobs_id_seq TO commerce_saas;
GRANT SELECT ON platform_bootstrap.queue_state TO commerce_saas;
```

Give workers their own login with the necessary secret-store and queue row/sequence privileges, without schema/database/role creation rights. Completion also needs INSERT on `platform_provisioning.readiness_deliveries`; enabled SMTP senders additionally need SELECT/UPDATE there. A separate [readiness sender](READINESS_EMAIL.md) can use a narrower account. Commerce/admin secret readers need SELECT on the three security tables and `PlatformSecurity:ReadOnly=true`; restrict other component privileges to their actual needs. Apply reviewed grants again for new tables introduced by later owner migrations. Runtime accounts must not own the database or schema and must not inherit the owner role.

Use [saas.example.json](../infra/portable/saas.example.json) with `DatabaseBootstrap:Mode=External`, `LocalDemo:Enabled=false`, and both security/queue `InitializeSchema=false`. Use runtime connections and the original shared key. Set `Provisioning:DeploymentId` to the bootstrapped id. Before enabling trial enrollment, copy the exact bootstrapped plan GUID to `TenantOnboarding:Trial:PlanId` and set `Enabled=true`. Configure the worker's matching deployment, identity, domains and shared directories as described in [PORTABLE_PROVISIONING.md](PORTABLE_PROVISIONING.md).

`External` startup verifies migration history, completed SaaS ownership, deployment identity and the selected active/public trial plan. Production without an explicit mode defaults to `Existing` migration verification for compatibility. Neither mode runs migrations or seeds plans/payment providers. Only explicit LocalDemo retains demo migrations and its three sample plans.

## Verification

```sh
python3 scripts/smoke_database_bootstrap.py
```

This creates a uniquely named loopback PostgreSQL container on port 15442, uses a nonsuperuser database owner, invokes independent CLI processes, and tests real SaaS startup with SELECT-only permissions. It checks concurrent replay, ciphertext preservation, separate/shared queue databases, incomplete initialization, wrong deployments/keys, drift, missing ownership/data and refusal to adopt unowned tables. The fixture removes only its own container/volume/private configuration. It does not contact Azure, Google, DNS or devices. The actual Production HTTPS enrollment probe also uses the same owner bootstrap, creates a separate login with the illustrated row/sequence privileges and no schema/admin rights, starts the full SaaS host in External mode and enrolls two fresh owners. Its uniquely owned runtime role is removed after its fixture databases.
