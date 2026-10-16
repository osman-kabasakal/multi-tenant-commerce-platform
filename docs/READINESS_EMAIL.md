# Tenant readiness email

After every provisioning step succeeds, PostgreSQL atomically enqueues one readiness delivery in `platform_provisioning.readiness_deliveries`. The trigger runs in the same transaction as job completion, including older-style completion SQL. Mobile-required jobs still have to pass their existing completion guard. A publication checkpoint or a failed later step cannot send a ready email. The compatible filesystem ready snapshots remain diagnostic artifacts.

`Provisioning:ReadinessEmail:Provider=Smtp` starts the sender automatically with the normal provisioning worker. `Disabled` is the default. A separate `TenantManager --readiness-email-worker` mode can send from another machine/process using the shared queue and encryption key. It needs no Mongo administrator, Keycloak provisioning client, Google project-creator or installer access.

## Configure the sender

Copy [readiness-email.example.json](../infra/portable/readiness-email.example.json) to a private file. The example intentionally leaves the provider Disabled. Set it to `Smtp`, supply the actual relay/From address and original deployment/public parent domains, and provide these private settings:

- `PlatformSecurity:ConnectionString`: shared security database, using the sender account.
- `Provisioning:ConnectionString`: queue database using the sender account; defaults to the security database.
- `PlatformSecurity:AesGcm:MasterKeyFile`: this deployment's original shared key. Optional Azure selection remains available with its existing vault/key settings.
- `Provisioning:ReadinessEmail:Smtp:UserName` and `Password`: a compatible relay's credentials, when required. Supply them through a deployment secret manager. Environment keys use `__`, for example `Provisioning__ReadinessEmail__Smtp__Password`.

Portable mode requires Production or Staging, `LocalDemo:Enabled=false`, HTTPS parent origins and `EnableStartTls=true`. The sender uses the platform certificate trust store and does not install certificate bypass callbacks. Use a relay supporting STARTTLS; implicit-only SMTPS is outside this transport. The underlying [.NET SMTP TLS behavior](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail.smtpclient.enablessl) rejects a server that does not advertise STARTTLS.

Local mode requires Development, `LocalDemo:Enabled=true` and a loopback SMTP capture endpoint. Plaintext captures additionally require `EnableStartTls=false` and `AllowPlaintextLoopback=true`; these settings are refused in Portable mode. The standard demo retains its current local captures until a separate local SMTP server is explicitly selected. The self-contained verification command below starts its own temporary loopback SMTP capture server.

## Schema and privileges

Run the original [owner database bootstrap](DATABASE_BOOTSTRAP.md) before enabling delivery. Its queue initializer installs the outbox, version marker and completion trigger. A repeated owned bootstrap upgrades that schema and preserves receipts. Runtime senders never initialize schemas; delivery-only mode rejects either InitializeSchema flag. A missing installed outbox is a restore error, and is not silently recreated. This workflow does not adopt older unowned databases; those still need their separately reviewed migration.

For a dedicated sender login, grant only the required privileges with the database owner. Set the login password interactively/outside Git. In the security database:

```sql
GRANT USAGE ON SCHEMA platform_security TO readiness_sender;
GRANT SELECT ON platform_security.secrets TO readiness_sender;
GRANT INSERT ON platform_security.secrets TO readiness_sender;
```

The INSERT privilege selects the immutable encrypted deployment sender binding. The sender does not rotate keys, update tenant credentials or initialize tables. In the queue database:

```sql
GRANT USAGE ON SCHEMA platform_provisioning TO readiness_sender;
GRANT SELECT ON platform_provisioning.jobs TO readiness_sender;
GRANT SELECT, UPDATE ON platform_provisioning.readiness_deliveries TO readiness_sender;
```

An ordinary provisioning worker also needs INSERT on `platform_provisioning.readiness_deliveries` for the completion trigger. For example, grant `GRANT INSERT ON platform_provisioning.readiness_deliveries TO commerce_worker;` in the queue database. When it runs the sender in the same host, add the sender's SELECT/UPDATE privileges. Do not grant schema ownership, CREATE, superuser, database creation or role administration to runtime accounts.

## Start in the normal worker or separately

For combined operation, merge the ReadinessEmail section into the normal private worker configuration and use the existing `--provisioning-worker` entry point. For a separate sender, build and start from the checkout root:

```sh
(cd TenantManager && dotnet publish -c Release -o ../.local/production/readiness-worker)
DOTNET_ENVIRONMENT=Production Provisioning__ConfigPath=/absolute/private/readiness.json dotnet .local/production/readiness-worker/TenantManager.dll --readiness-email-worker
```

Multiple sender replicas can share the same database/key. Every deployment has an atomically selected encrypted sender binding. It pins relay host/port, From address, TLS policy and owned store/admin origins. Password/username rotation keeps the binding unchanged. Moving a deployment or relay is an explicit migration; deleting the system binding does not override incompatible durable receipt fingerprints.

The sender derives the recipient and public links from the immutable provisioning request and verified publication checkpoint. It checks deployment, profile and exact owned URLs again before contacting SMTP. Messages contain the store name and public store/admin links; no password, database credential, signing key or service-account material is included. Worker logs contain canonical tenant ids and safe error types, not recipient addresses or relay response bodies.

## Delivery state and retries

Job Succeeded means tenant setup completed. SMTP acceptance is recorded independently as Sent; it does not prove inbox delivery or a device notification. A failed send keeps the tenant ready and retries with bounded exponential backoff. Claims renew while the SMTP server is slow; stale senders cannot acknowledge another worker's claim. A job suspended after readiness cannot be claimed for email delivery.

Inspect a known tenant's metadata with an authorized queue account:

```sql
SELECT tenant_id, state, attempts, error_code, updated_at
FROM platform_provisioning.readiness_deliveries
WHERE tenant_id = 'the-canonical-business-guid-without-dashes';
```

After correcting a Failed delivery, an operator can retry only that notification without rerunning installation:

```sql
UPDATE platform_provisioning.readiness_deliveries
SET state='Pending', available_at=now(), error_code=NULL, updated_at=now()
WHERE tenant_id='the-canonical-business-guid-without-dashes' AND state='Failed';
```

Attempt history is retained. Ordinary replay does not resend Sent events. SMTP has an unavoidable ambiguity if the server accepts mail but the process loses its response or exits before journaling Sent; a retry uses the same stable Message-ID, but exactly-once mailbox delivery is not promised. Enabling the sender processes pending records for that deployment, including records created while the provider was Disabled. Schema installation does not backfill tenants that were already Succeeded before the trigger existed.

## Verification

```sh
dotnet test tests/Portable.Provisioning.Tests/Portable.Provisioning.Tests.csproj -c Release
python3 scripts/smoke_readiness_email.py
```

The isolated probe uses actual PostgreSQL, a TCP SMTP capture server, real MIME messages and the actual separate TenantManager delivery-only host with a nonowner row-only database login. It verifies concurrency, heartbeat, transient rejection, recovery, dead-letter retry, stable Message-ID, tenant/deployment isolation and TLS downgrade refusal. It creates only a uniquely named local container/database and removes its private configuration/captures. No external mail provider or real recipient is contacted. Live relay authentication/TLS/inbox delivery remains separate verification. FCM/device delivery remains in [NOTIFICATIONS.md](NOTIFICATIONS.md).
