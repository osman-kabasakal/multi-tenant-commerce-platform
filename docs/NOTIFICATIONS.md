# Tenant notifications

Commerce sends through `Shared/Platform.Notifications.ITenantPushSender`. Select the provider explicitly in the host configuration. It does not require Azure. Tenant encryption can independently use the portable or optional Azure provider from [TENANT_SECURITY.md](TENANT_SECURITY.md).

## Providers

```json
{
  "Notifications": { "Provider": "Fcm" }
}
```

- `Fcm` resolves the authenticated tenant/store alias to the canonical business ID, reads that business's encrypted `firebase-configuration` secret and sends to its own Google project. The onboarding Google provider creates this configuration and grants the configured sender account the target-project FCM role; see [GOOGLE_FIREBASE.md](GOOGLE_FIREBASE.md). Every commerce replica uses the same security database/key and its deployment's sender ADC identity. Runtime senders need FCM permission; they do not need Google project creation, IAM administration or `AllowCloudWrites`.
- `FcmApns` retains FCM for Android and sends native iOS registrations directly through APNs. It requires explicit Production/Staging, the shared operator APNs team key and matching encrypted tenant metadata. See the direct APNs setup below.
- `LocalSink` captures messages in `<LocalDirectory>/<canonical-business-id>/push/*.json`. It requires Development, `LocalDemo:Enabled=true` and an absolute directory. `demo.py prepare` supplies these settings automatically. Captures are written atomically with owner-only Unix file permissions, and store device-token SHA-256 values rather than raw tokens. They are local captures, not device deliveries.
- `Disabled` is the default when no provider is configured. Sending fails explicitly; it does not report a successful delivery or switch to another provider.

For local capture outside the launcher, supply `Notifications:Provider=LocalSink` and `Notifications:LocalDirectory` through a private development configuration. The Google provisioning provider and the runtime notification provider are independent selections: enabling Google setup alone does not switch the default demo away from LocalSink. To test actual cloud sends, configure the commerce/admin hosts with `Notifications__Provider=Fcm` and the sender's ADC identity as well.

## Direct APNs for iOS

This path avoids a per-tenant Firebase-console APNs-key upload. Crashlytics and App Distribution still use each tenant's Firebase app. The Apple provisioner enables push on every owned main App ID automatically. One **Production, Team Scoped** APNs key serves apps under the selected Apple Developer team; do not create a new key for each business. This key is distinct from the App Store Connect API key and the Mac's Apple Distribution signing identity.

For generated Linux Compose, merge [apns.example.json](../infra/production/apns.example.json) into the existing private deployment input. Fill `Providers:Notifications:Apns:DevelopmentTeam`, `KeyId` and the absolute `KeyFile`. Keep the configured Google provider, separate FCM sender credential and optional combined mobile policy. The APNs team must equal the iOS signing team. The generator passes only `IosPushTransport=Apns` and `IosDevelopmentTeam` to the provisioning worker's Google section; supply those same public fields in the Mac worker's `Provisioning:Google` section. It mounts the copied 0600 key read-only only in commerce/admin, disables notifications in the installer and never gives the key to SaaS, the gateway or mobile artifacts. The state backup retains it and restoration rebinds the key to recovered private inputs instead of requiring the original operator file.

Standalone commerce/admin hosts select `Notifications:Provider=FcmApns` and `Notifications:Apns` with `Environment=Production`, the same `DevelopmentTeam`, `KeyId`, absolute `KeyFile` and optional `LifetimeSeconds` (default 3600, bounded 0–86400). Use a regular P-256 private `.p8` file without linked path components or group/other access. Startup verifies the key locally before serving; this does not prove Apple has authorized that key. The server caches ES256 provider tokens for 40 minutes, requires a synchronized clock, fixed Apple HTTPS endpoints and HTTP/2, and selects the topic from the authoritative tenant record. Key values and provider JWTs must never enter public manifests or logs.

New Firebase records and public SDK exports bind `iosPushTransport=Apns` and `iosDevelopmentTeam`. The immutable iOS release plan, native result and completion checkpoints retain that selection. Native preparation sets the app's matching team/transport and disables Firebase Messaging automatic registration. Flutter uses the native APNs bridge, refreshes registration at launch and on renewal, and stores the device token in the existing consent-controlled tenant registration flow with the versioned prefix `apns-v1:production:`. The mixed sender keeps these registrations away from FCM. A legacy FCM-only sender refuses them. User-provided topics or team IDs cannot override the saved tenant target.

Visible alerts support foreground presentation, initial/opened action links and the notification extension. The extension accepts bounded HTTPS JPEG/PNG/GIF attachments up to 10 MiB without following redirects, falls back to text on failure/expiry and completes once. Data-only notifications use Apple's background headers; native receipt does not claim application data was fetched. Device permissions, delivery scheduling and OS background restrictions remain real-device acceptance checks.

Enable the policy before enrolling new tenants. Existing saved Firebase identities and completed initial releases are immutable; changing FCM/APNs/team/source requires an explicit migration and compatible app release. The direct path targets Production/ad hoc apps; sandbox/debug APNs registrations are refused. The [Turkish new-business guide](YENI_ISLETME_EKLEME.md) distinguishes once-only setup from each owner's registration and delivery tests.

## Tenant routing and failures

HTTP calls obtain the store identity from the verified request route, using the same context as tenant database selection. An HTTP request without a routed tenant cannot fall back to an ambient/default store. Background callers must explicitly supply their trusted tenant identity. Missing, conflicting or foreign Firebase configuration is rejected. There is no process-global Firebase application that can be changed by another tenant.

Batches contain at most 500 unique registration tokens. An individually rejected token can fail while other recipients are accepted; permission/quota/server failures propagate as sanitized errors. Commerce records accepted-recipient counts only after a successful send. Provider acceptance does not prove a device displayed a notification. A failure partway through multiple batches can produce partial delivery; no exactly-once delivery guarantee is made.

Visible messages retain action links, HTTPS images, Android notification channels and APNs alert options. Data-only messages use background APNs headers. For the `Fcm` path, real iOS delivery additionally requires the target Firebase app's APNs credentials. The `FcmApns` path above sends directly with the operator key. Both need an appropriately signed/entitled client and real-device verification; unsigned compilation is insufficient.

## Consent and administrator settings

The existing storefront registration action stores notification consent in that tenant's database. Revoking consent excludes the customer from later sends. Flutter now sends registration values in the form body instead of a URL containing the device token, and sends the server's explicit revocation value when permission is denied/not determined. It does not log response bodies for this operation.

Administrators send through the normal protected notification screen. It no longer requires a legacy FCM server key. Private API key and service-account upload controls were removed, and the settings action rejects new private credential submissions. Existing legacy credential values are preserved verbatim; this change neither migrates nor deletes persisted credentials. Assess and remove obsolete credentials through an explicit migration if an older deployment stored them.

Public browser Firebase fields remain tenant settings. Saving them no longer overwrites a shared `firebase-messaging-sw.js` for every tenant. Automatic browser Web App/VAPID/service-worker integration is not implemented by this mobile-focused Google setup yet; do not treat these fields as a completed browser-push deployment. The legacy Redis FCM cache-invalidation consumer also remains disabled; the new sender does not silently activate it.

## Repeat the verified local flow

```sh
python3 scripts/demo.py up
python3 scripts/smoke_onboarding.py --fresh
python3 scripts/demo.py smoke
```

The onboarding smoke creates two real verified owners/businesses, installs their stores, registers notification consent through the storefront, signs into the actual tenant admin, sends a message and verifies the canonical tenant capture. It then revokes consent and confirms the token receives no later message. It also checks that settings expose no private credential input and reject a private-credential submission. This is an HTTP/infrastructure test; it does not emulate a Firebase device.

To repeat only notification checks for an existing test fixture:

```sh
python3 scripts/smoke_notifications.py --fixture .local/onboarding-smoke.json
```

Choose the actual ignored fixture file if the businesses were created with `--fresh`. Unit/contract checks run without Docker or cloud accounts:

```sh
dotnet test tests/Notifications.Tests/Notifications.Tests.csproj -c Release
dotnet test tests/Google.Provisioning.Tests/Google.Provisioning.Tests.csproj -c Release
dotnet test tests/Storefront.Binding.Tests/Storefront.Binding.Tests.csproj -c Release
```

Remaining platform/deployment gates are tracked in [PROVISIONING.md](PROVISIONING.md). Live FCM delivery, APNs configuration, Firebase-enabled signed mobile builds, Crashlytics reports and cloud deployment have not yet been verified.

Readiness email after completed tenant setup is handled by the separate [durable SMTP sender](READINESS_EMAIL.md). It is independent of device push and can run with only its shared database/key and relay configuration.
