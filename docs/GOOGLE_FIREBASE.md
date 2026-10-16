# Per-tenant Google and Firebase

The durable onboarding worker has an **opt-in Google provider**. The default local demo keeps `Provisioning:Google:Provider=Disabled` and creates no cloud resources. The Google provider plugs into both the Local and Portable orchestration profiles. You can exercise Google setup while keeping the database, Keycloak and storefront local, or explicitly configure it in a Portable deployment. Opt-in automatic Android release orchestration, encrypted tenant signing and durable artifact replay are implemented. The complete signed Android Flutter release passed clean Linux CI with synthetic Firebase identity. iOS, live notification/crash/distribution delivery and complete deployment verification remain acceptance gates; see [PROVISIONING.md](PROVISIONING.md).

## Resources and ownership

For every newly queued tenant, the `google-firebase` step:

1. Derives a stable project ID from the configured deployment ID and canonical business GUID. A tenant slug or display name is never the ownership key.
2. Creates/reconciles an active Google project under the explicitly configured folder or organization. Both `platform-tenant` and `platform-deployment` labels and the parent must match before reuse. It refuses foreign or deleted projects.
3. Links the optional explicitly supplied billing account, refusing to replace another account. Leaving it null does not require the worker to link a billing account; it does not remove billing inherited from an existing project.
4. Enables Firebase Management, Installations, FCM, Crashlytics and App Distribution APIs and adds Firebase. Long-running operations are polled, bounded and checked for errors.
5. Lists all Android/iOS app pages, reconciles package/bundle IDs, downloads client SDK configuration and validates its project/app identity.
6. Adds the configured central sender service account to the target project's `roles/firebasecloudmessaging.admin` binding. Existing bindings, conditions and IAM etags are retained. An IAM conflict fails safely and is reconciled on retry.
7. Creates the App Distribution group and adds only explicitly configured testers. `IncludeOwnerAsTester=true` also invites the owner; leave it false to avoid automatic tester invitations.
8. Stores backend resource configuration under the canonical tenant's encrypted `firebase-configuration` secret. Job checkpoints contain public IDs only. It never creates service-account keys.

A process crash before its checkpoint replays these checks. The outer durable queue's retry/lease rules still apply. Changing deployment identity or moving an already provisioned tenant to another project requires an explicit migration. Jobs already completed with Google disabled are not silently re-provisioned when the global provider is changed.

## Prerequisites

Choose the folder/organization, stable deployment ID, sender service account and optional billing account yourself. The operator must have accepted applicable Google/Firebase terms and have sufficient project quota. Organization policy can prohibit project creation or service activation; the worker reports failure rather than pretending setup succeeded.

Use Application Default Credentials (ADC) for the worker and management tool. Attached service accounts or Workload Identity Federation avoid generating long-lived private keys. Local service-account impersonation is also supported by Google's ADC library. If you intentionally use a key file, keep it outside Git and point `GOOGLE_APPLICATION_CREDENTIALS` at it. Never place it in a mobile artifact or public manifest.

The provisioning identity needs these capabilities on the configured parent/new projects (grant the narrow organization-approved roles that contain them):

- `resourcemanager.projects.create/get`, and new-project `resourcemanager.projects.getIamPolicy/setIamPolicy`.
- `serviceusage.services.enable/get`; enabling the Service Usage, Resource Manager and Firebase Management APIs in the credential/quota project may be a one-time administrator action.
- `firebase.projects.get/update`, `firebase.clients.list/get/create` for app setup.
- App Distribution group/tester administration and release upload/distribution for the management command.
- When a billing account is supplied, project billing assignment and permission to associate that account.

The runtime sender is a separate, narrower identity. Configure it as `SenderServiceAccount`; enable the Firebase Cloud Messaging API in its sender project too. Run the eventual commerce sender using that identity's ADC credentials. It needs the per-target FCM role above, not project creation, IAM administration or service-account key creation. Commerce now uses this shared tenant sender. Select `Notifications:Provider=Fcm` on the commerce/admin hosts; runtime delivery uses the sender identity and does not require provisioning write options. See [NOTIFICATIONS.md](NOTIFICATIONS.md) for local capture, consent and verification limits.

## Enable Google for a local test

Start with a working local demo. Copy `infra/google/provisioning.example.json` to an ignored location. Replace its target values and intentionally set `AllowCloudWrites=true`. Never enable it just to run the default demo.

The example is only the `Provisioning:Google` section, not a complete worker configuration. Either merge it into a private copy of `.local/tenantmanager.json` and point `Provisioning__ConfigPath` at that absolute file before starting the demo, or supply its individual `Provisioning__Google__*` environment variables. Environment variables take precedence over generated files. For example, after completing a private merged config:

```sh
Provisioning__ConfigPath="$PWD/.local/google-worker.json" python3 scripts/demo.py up
```

The merged file must retain the generated local database, Keycloak, installer and security settings. Do not edit only `.local/tenantmanager.json` and then run `up`: the launcher regenerates that file with Google disabled. The explicit private copy survives regeneration. Provisioning starts cloud writes only when a **new** onboarding job reaches the Google step. Billing links and tester invitations are real effects when configured.

Create a new local trial through the SaaS onboarding page. The new job has a `google-firebase` checkpoint before publication. SDK files appear under `.local/mobile/<slug>/`; the manifest has `firebase.enabled=true`. `scripts/mobile_tenant.py` deliberately accepts only the Firebase-disabled debug profile. The separate isolated Android runner in [MOBILE.md](MOBILE.md#prepare-a-firebase-enabled-tenant-android-release) requires a Portable publication manifest with `localDemo=false` and the verified HTTPS store origin; a Local-profile Google probe does not turn a demo manifest into a release deployment. API activation alone does not establish Crashlytics SDK initialization, symbols or delivery.

## Enable Google in Linux Compose

Start from the private deployment input in [LINUX_PRODUCTION.md](LINUX_PRODUCTION.md). The generated Compose profile reads `Providers:Google`, while the standalone worker example wraps the same options in `Provisioning:Google`. Copy only that inner Google object into `Providers:Google`. Keep its stable `DeploymentId` equal to the deployment input’s `DeploymentId`; replace the parent, project prefix and sender service account deliberately. Set `AllowCloudWrites=true` only for the Google targets you intend new tenant jobs to create.

The private deployment input accepts two separate absolute credential paths:

```json
{
  "GoogleCredentialsFile": "/absolute/private/provisioning-adc.json",
  "NotificationCredentialsFile": "/absolute/private/notification-sender-adc.json"
}
```

This is a fragment of the existing deployment input. The first identity is mounted only in the provisioning worker; the second is mounted only in commerce/admin. The runtime identity must correspond to `Providers:Google:SenderServiceAccount`, whose per-tenant FCM permission the worker grants. Select `Providers:Notifications:Provider=Fcm` for real sending. Both files stay outside Git and are copied into private 0600 deployment state. An external-account ADC configuration that refers to a separate local token file also needs an explicit private Compose mount at its referenced container path; the launcher does not copy arbitrary credential dependencies. Never reuse the project/IAM administrator credential as the runtime notification sender.

Run the ordinary `production.py up` with that private input. Existing completed tenants keep their original Google checkpoint; enable this before enrolling the new businesses that should receive projects. A Google failure remains a failed/retryable setup job and never proves successful tenant publication. Start with one explicitly configured tenant and verify its owned project, SDK identity and permission boundaries before broader enrollment. This configuration path is implemented; live Google accounts and device delivery have not been exercised by the cloud-free CI.

The baseline server Compose image does not contain Flutter/Android tools. Automatic App Distribution additionally requires the dedicated mobile worker configuration and toolchain in [MOBILE.md](MOBILE.md#automatic-android-publication-from-a-saas-subscription), with the provider selected in both SaaS and worker. Merely selecting Google in this server profile does not build or distribute an app.

## Export public SDK files and distribute an existing build

The server-side management tool reads the same encrypted tenant store, with schema initialization disabled and read-only database access. Its configuration must contain the actual `PlatformSecurity` provider/key/connection. For a local security provider, explicitly set `DOTNET_ENVIRONMENT=Development` and retain `LocalDemo:Enabled=true`. For production use the portable or optional Azure provider from [TENANT_SECURITY.md](TENANT_SECURITY.md).

```sh
dotnet run --project tools/Platform.Cloud -- export-mobile \
  --config /absolute/private/operator.json --tenant BUSINESS_GUID_N \
  --output "$PWD/.local/firebase/BUSINESS_GUID_N"

dotnet run --project tools/Platform.Cloud -- distribute \
  --config /absolute/private/operator.json --tenant BUSINESS_GUID_N \
  --platform android --binary /absolute/path/app.apk
```

`export-mobile` performs no Google API call and does not require Google write permission. It exports only `google-services.json`, `GoogleService-Info.plist` and a public client manifest, with owner-only file permissions on Unix. `distribute` requires the configured Google provider and `AllowCloudWrites`, rechecks cloud project ownership, uploads the APK (or signed IPA with `--platform ios`), waits for the release and distributes only to that tenant's configured group. It rejects a release resource belonging to another app. A repeated identical binary can reuse the release according to the provider's upload contract.

These commands do not sign an app or claim an existing APK has Crashlytics integrated. An explicit isolated Android build/sign/verify/distribute runner is now available in [MOBILE.md](MOBILE.md#prepare-a-firebase-enabled-tenant-android-release). Automatic onboarding-to-release scheduling, encrypted per-tenant signing and durable artifact replay are implemented in the explicit Android provider. The real signed Flutter build passed [Linux CI run 38859826592](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/runs/38859826592); that synthetic run disabled cloud uploads and did not install a device app. The complete Compose mobile worker, iOS signing and live crash/distribution verification remain required before a complete automatic mobile deployment is proven.

## Verify without a cloud account

```sh
dotnet test tests/Google.Provisioning.Tests/Google.Provisioning.Tests.csproj -c Release
```

HTTP contract tests exercise the real provisioning, secret adapter, publication, FCM and App Distribution code against isolated in-memory HTTP responses. They cover replay, partial failure, async operations, ownership mismatch, IAM concurrency/conditions, billing conflicts, pagination, config validation, per-tenant FCM routing and binary upload/distribution. They never load ADC or call live Google services. A configured live project, device notification and signed release still need separate verification.

Official API references: [Firebase management](https://firebase.google.com/docs/projects/api/workflow_set-up-and-manage-project), [FCM HTTP v1 and cross-project authorization](https://firebase.google.com/docs/cloud-messaging/send/v1-api), [App Distribution upload](https://firebase.google.com/docs/reference/app-distribution/rest/v1/upload.v1.projects.apps.releases/upload), [tester groups](https://firebase.google.com/docs/reference/app-distribution/rest/v1/projects.groups/batchJoin), [Flutter Crashlytics setup](https://firebase.google.com/docs/crashlytics/flutter/get-started).
