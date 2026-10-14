# Architecture

This is a source-only monorepo extracted into a separate directory. Original Git histories, credentials, generated plugins, customer catalogs and signing material are excluded. Existing project paths are retained to preserve references.

```mermaid
flowchart LR
    Browser[Storefront browser] --> Gateway[Local gateway :18090]
    Mobile[Flutter debug app] --> Gateway
    Gateway -->|client credentials| KC[Keycloak :18080]
    Gateway -->|x-store-token| Commerce[.NET commerce :18082]
    Commerce -->|verify signature, audience, expiry and tenant| KC
    Commerce --> A[(Mongo: demo_a)]
    Commerce --> B[(Mongo: demo_b)]
    Admin[Store admin :18083] -->|fixed hostname route + password login| A
    Admin -->|fixed hostname route + password login| B
    SaaS[Angular + SaaS API :18081] -->|OIDC| KC
    SaaS --> PG[(PostgreSQL)]
    Commerce --> Redis[(Redis)]
    SaaS --> Redis
    Installer[Local installer] --> A
    Installer --> B
```

## Trust boundaries

The loopback gateway maps only known hosts to the two demo tenants. Keycloak service credentials stay on the host; browser and mobile bundles contain no confidential client secret. The commerce middleware still verifies issuer, audience, signature, expiration and tenant claims. Tenant store/database claims are encrypted using distinct, locally generated AES-GCM keys.

The admin profile maps the same fixed hosts to local tenant databases, then relies on GrandNode's ordinary authenticated admin flow. The local adapters refuse to start outside `Development`. All exposed ports bind to `127.0.0.1`. HTTP and Keycloak `start-dev` are deliberate local-only choices.

Do not expose this profile to the internet. MongoDB and Redis are loopback services without application-level authentication in this profile. Key material, generated credentials, runtime applications and logs live under ignored `.local/`.

## Cloud workflow retained as source

The original SaaS registration pipeline persists registration/subscription state and publishes Redis events. `TenantManager` consumes tenant/build events, orchestrates the installer, Azure deployment and Google/Firebase project/mobile build helpers. The installer creates the store database and identity metadata. Credential/build-completion events feed back into SaaS. The mobile builder supplies tenant-specific public configuration and signing/service configuration.

The local profile replaces Azure Key Vault/encryption with explicit file-backed adapters and uses two fixed tenants. It does not invoke Azure deployment, Google/Firebase provisioning, DNS changes, payment providers, mobile signing or app-store publishing. The corresponding code is retained for a separate cloud profile, not presented as validated deployment instructions.

## Engineering changes in this extraction

- Environment-derived configuration and local-only adapters; no copied machine user-secret IDs.
- Server-side Keycloak service tokens and RSA/EC verification support.
- Expiry verification remains active for the query-token path.
- Real commerce installer creates synthetic products in separate databases.
- Angular demo configuration, local mail sink and disabled billing mutations.
- Flutter debug profile skips Firebase/device attestation requirements and removes insecure certificate acceptance.
- Mobile request logging excludes credentials and request/response bodies.
- Fresh Git repository; CodeGraph index remains untracked.

## Limits

The Python gateway does not proxy WebSockets and limits request bodies to 10 MiB. Push notifications, cloud storage, payment checkout, automated tenant creation and the cloud build queue are outside the local demo. Existing framework/dependency warnings remain; passing a smoke check is not a complete security audit or a production readiness assessment.
