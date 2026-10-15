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

Ten tests cover the real card provider and existing encryption engine, cross-business/master-key/tamper denial, CVV exclusion, filesystem traversal/symlink/size/cancellation handling, independent-instance reads, handler ownership, and Azure SDK CRUD through an HTTP test transport. No real payment or Azure resources are used. The SaaS Web Release build passes with inherited compiler warnings. Live HTTP upload/download, full portable production startup, deployment, and remote CI for this snapshot remain unverified; see [PROVISIONING.md](PROVISIONING.md).
