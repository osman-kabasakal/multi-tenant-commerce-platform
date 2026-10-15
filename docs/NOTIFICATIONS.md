# Tenant notifications

Commerce sends through `Shared/Platform.Notifications.ITenantPushSender`. Select the provider explicitly in the host configuration. It does not require Azure. Tenant encryption can independently use the portable or optional Azure provider from [TENANT_SECURITY.md](TENANT_SECURITY.md).

## Providers

```json
{
  "Notifications": { "Provider": "Fcm" }
}
```

- `Fcm` resolves the authenticated tenant/store alias to the canonical business ID, reads that business's encrypted `firebase-configuration` secret and sends to its own Google project. The onboarding Google provider creates this configuration and grants the configured sender account the target-project FCM role; see [GOOGLE_FIREBASE.md](GOOGLE_FIREBASE.md). Every commerce replica uses the same security database/key and its deployment's sender ADC identity. Runtime senders need FCM permission; they do not need Google project creation, IAM administration or `AllowCloudWrites`.
- `LocalSink` captures messages in `<LocalDirectory>/<canonical-business-id>/push/*.json`. It requires Development, `LocalDemo:Enabled=true` and an absolute directory. `demo.py prepare` supplies these settings automatically. Captures are written atomically with owner-only Unix file permissions, and store device-token SHA-256 values rather than raw tokens. They are local captures, not device deliveries.
- `Disabled` is the default when no provider is configured. Sending fails explicitly; it does not report a successful delivery or switch to another provider.

For local capture outside the launcher, supply `Notifications:Provider=LocalSink` and `Notifications:LocalDirectory` through a private development configuration. The Google provisioning provider and the runtime notification provider are independent selections: enabling Google setup alone does not switch the default demo away from LocalSink. To test actual cloud sends, configure the commerce/admin hosts with `Notifications__Provider=Fcm` and the sender's ADC identity as well.

## Tenant routing and failures

HTTP calls obtain the store identity from the verified request route, using the same context as tenant database selection. An HTTP request without a routed tenant cannot fall back to an ambient/default store. Background callers must explicitly supply their trusted tenant identity. Missing, conflicting or foreign Firebase configuration is rejected. There is no process-global Firebase application that can be changed by another tenant.

Batches contain at most 500 unique registration tokens. An individually rejected token can fail while other recipients are accepted; permission/quota/server failures propagate as sanitized errors. Commerce records accepted-recipient counts only after a successful send. Provider acceptance does not prove a device displayed a notification. A failure partway through multiple batches can produce partial delivery; no exactly-once delivery guarantee is made.

Visible messages retain action links, HTTPS images, Android notification channels and APNs alert options. Data-only messages use background APNs headers. Real iOS delivery additionally requires configuring the target Firebase app's APNs credentials and an appropriately signed/entitled client. That device/configuration verification is still pending.

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
