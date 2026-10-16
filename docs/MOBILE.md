# Flutter local demo

Prerequisites: Flutter 3.44.6, Android Studio/SDK, a compatible JDK and an Android emulator. The web demo must already be running. Allow at least 15 GiB free for SDK downloads, Gradle caches and APK output.

```sh
cd Platforms/store_user_app
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter build bundle --debug \
  --dart-define=LOCAL_DEMO=true \
  --dart-define=STORE_URL=http://127.0.0.1:18090 \
  --dart-define=APP_TITLE='Commerce Demo' \
  --dart-define=PACKAGE_NAME_ANDROID=dev.commerce.demo
```

For an Android emulator, inspect the device list first and use its explicit identifier:

```sh
flutter devices
adb -s <emulator-id> reverse tcp:18090 tcp:18090
flutter run -d <emulator-id> --debug --flavor demo \
  --dart-define=LOCAL_DEMO=true \
  --dart-define=STORE_URL=http://127.0.0.1:18090 \
  --dart-define=APP_TITLE='Commerce Demo' \
  --dart-define=PACKAGE_NAME_ANDROID=dev.commerce.demo
```

The verified ARM64 APK build is:

```sh
flutter build apk --debug --flavor demo --split-per-abi \
  --target-platform android-arm64 \
  --dart-define=LOCAL_DEMO=true \
  --dart-define=STORE_URL=http://127.0.0.1:18090 \
  --dart-define=APP_TITLE='Commerce Demo' \
  --dart-define=PACKAGE_NAME_ANDROID=dev.commerce.demo
adb -s <emulator-id> install -r build/app/outputs/flutter-apk/app-arm64-v8a-demo-debug.apk
adb -s <emulator-id> shell am start -n dev.commerce.demo/com.famizyo.store_user_app.MainActivity
```

Run `adb reverse` before launching the installed APK as well. This APK targets ARM64; for an x86 emulator, use `flutter run` with that emulator's identifier or build for its architecture. Do not install the demo over another application's package.

The localhost alias selects Demo Coffee. Do not embed a Keycloak confidential client secret in Dart defines. The local gateway obtains the store token server-side.

`LOCAL_DEMO=true` is allowed only in debug builds. Firebase messaging/analytics/crash reporting and device integrity checks are skipped in that profile. The repository contains no release signing credentials; the explicit tenant release profile below requires an operator-supplied private key. Customer-specific flavors, signing files and Firebase service configuration have been removed. Android cleartext access is enabled in the debug manifest only.

Validation on 2026-10-14: debug bundle and ARM64 APK compilation passed. On an API 36 ARM64 emulator, the app loaded the local catalog, opened Demo Espresso, added one item to the cart and displayed the $10.00 total. The web service's smoke checks also exercise guest tokens, catalogs and carts for both tenants. Static analysis reported no errors and 2,587 inherited warnings/information messages.

The demo uses `/TenantTokenWeb` for customer tokens, matching the server's tenant-specific signing keys. Notification polling and the optional slider plugin are skipped in the local profile. Product images use neutral placeholders. Full checkout, account registration, long-running token refresh, iOS, physical devices and release distribution remain unverified; see [VALIDATION.md](VALIDATION.md).

Compatibility references used for the dependency repair: [Skeletonizer changelog](https://pub.dev/packages/skeletonizer/changelog), [Google Fonts changelog](https://pub.dev/packages/google_fonts/changelog), [Android Gradle Plugin 8.9 compatibility](https://developer.android.com/build/releases/agp-8-9-0-release-notes). Dependencies are resolved in `pubspec.lock`.


## Select a newly provisioned local business

After creating the business through the SaaS local onboarding page, run:

```sh
python3 scripts/mobile_tenant.py <tenant-slug>
cd Platforms/store_user_app
flutter build bundle --debug --dart-define-from-file=../../.local/mobile/<tenant-slug>.defines.json
# After selecting an emulator with flutter devices and configuring adb reverse:
flutter run -d <emulator-id> --debug --flavor demo --dart-define-from-file=../../.local/mobile/<tenant-slug>.defines.json
```

The generated file contains public configuration only. `STORE_URL` defaults to the loopback gateway, while the debug-only `LOCAL_TENANT_HOST` selects the published tenant host. For Android without `adb reverse`, use `python3 scripts/mobile_tenant.py <tenant-slug> --base-url http://10.0.2.2:18090`. Invalid/nonlocal tenant-host overrides and release use of LocalDemo are rejected.

This uses the existing `demo` flavor. Switching demo tenants can replace the same installed demo application; clear its data to avoid stale local customer sessions. A new-tenant debug bundle and server mobile token/catalog flow were verified; a new device/emulator run was not performed in this phase. Tenant-specific signed Android builds use the explicit profile below. IPA signing and live Crashlytics/App Distribution delivery remain cloud-profile acceptance work.

## Tenant notification registration

Firebase-enabled builds send notification registration through the authenticated storefront client, with form-body values instead of device tokens in URLs. Denied/not-determined permission sends the explicit revocation value expected by the backend. The default LocalDemo mobile profile still skips Firebase SDK initialization; local server captures and real storefront/admin consent checks are described in [NOTIFICATIONS.md](NOTIFICATIONS.md). No new Firebase-enabled device or signed release was run in this phase.


## Prepare a Firebase-enabled tenant Android release

The `tenant` Android flavor is generated from a published non-demo manifest and the public Firebase export. The build tool validates the canonical business GUID, owned HTTPS store origin, Android/iOS package identities and the project/sender/app ids across those inputs before copying sources. It reads only explicitly tracked mobile/module sources into a fresh isolated workspace. Paths inside the manifest never select files or executable commands. The running app compares its installed native package/Firebase identity with its public tenant build defines before initializing the rest of the application.

Use the manifest written by Portable tenant publication, then export that tenant's SDK files using [Platform.Cloud](GOOGLE_FIREBASE.md#export-public-sdk-files-and-distribute-an-existing-build). Preparation performs no signing or Google API call:

```sh
python3 scripts/mobile_android.py /absolute/private/mobile/TENANT_SLUG.json \
  --firebase-directory /absolute/private/firebase/BUSINESS_GUID_N \
  --build-number 1
```

It prints a fresh ignored `.local/mobile-builds/<id>` workspace. `tenant-build.json` and `tenant.defines.json` contain public identifiers only; `google-services.json` stays in the workspace's `android/app/src/tenant/`. Android Google Services and Crashlytics plugins are applied only when `PLATFORM_TENANT_CONFIG` selects this profile. Ordinary demo resource builds have neither plugin's tasks enabled. No tenant flavor, signing key or SDK file is written into the source checkout.

For a signed ARM64 APK, provide JDK 17 or newer, Flutter 3.44.6, Android SDK platform android-35/build-tools 35.0.0, NDK and at least 15 GiB free disk space. Put Java signing properties outside Git with owner-only permissions. The values are the real operator-selected key and passwords; use an absolute `storeFile` path. Keep this key and its backup for future updates of the application; this tool does not generate, rotate or recover signing keys.

```properties
storeFile=/absolute/private/android-release.jks
storePassword=YOUR_PRIVATE_STORE_PASSWORD
keyAlias=YOUR_KEY_ALIAS
keyPassword=YOUR_PRIVATE_KEY_PASSWORD
```

```sh
python3 scripts/mobile_android.py /absolute/private/mobile/TENANT_SLUG.json \
  --firebase-directory /absolute/private/firebase/BUSINESS_GUID_N \
  --build-number 1 --build \
  --signing-properties /absolute/private/android-signing.properties \
  --android-sdk /absolute/path/to/Android/sdk
```

The tool restores locked dependencies, builds `--release --flavor tenant` with `LOCAL_DEMO=false`, verifies the APK signature using `apksigner`, and reads its actual package/version with AAPT2. It writes the artifact path, SHA-256 and signing certificate fingerprint in private `build-result.json`. Signing passwords are passed through the private properties file, never command arguments or Dart defines. Build output belongs in private `build.log`. Timeouts terminate the tool's own child process group. Each invocation uses a new workspace; select increasing Android build numbers for later releases of the same package.

To upload and distribute only after that real signed build succeeds, append `--distribute-config /absolute/private/operator.json`. The existing Platform.Cloud command rechecks target project ownership and requires explicit Google `AllowCloudWrites` before distribution to the tenant's configured group. A prepared workspace is never treated as a built or distributed application. The Portable onboarding queue can now invoke this path automatically with per-tenant encrypted signing keys and immutable artifact replay, as configured below. The complete signed tenant Flutter compilation is verified in clean Linux CI with synthetic Firebase identity; see [VALIDATION.md](VALIDATION.md). iOS signing and live device/cloud verification remain acceptance gates.

Crashlytics now records uncaught framework errors as fatal and marks handled dispatcher errors as handled. A failed/mismatched Firebase initialization does not attempt to report to an unverified Firebase app. This profile uses the ordinary release compilation without `--obfuscate` or `--split-debug-info`; those modes require a separate Flutter symbol upload step before enabling them. See the official [Flutter Crashlytics setup and symbol guidance](https://firebase.google.com/docs/crashlytics/flutter/get-started) and [Android plugin setup](https://firebase.google.com/docs/crashlytics/android/get-started). Plugin/API activation and resource generation alone do not prove crash delivery; that needs a controlled device exception and dashboard evidence.

Cloud-free checks:

```sh
python3 -m unittest discover -s scripts -p test_mobile_android.py -v
(cd Platforms/store_user_app && flutter test --no-pub test/core/config/tenant_firebase_identity_test.dart)
# After a Flutter Android build has generated android/gradlew, or with --gradle /absolute/installed/gradle:
python3 scripts/smoke_mobile_android_profile.py --android-sdk /absolute/path/to/Android/sdk
```

The native profile probe uses only synthetic app identifiers and unused signing placeholders to run real Google Services/Crashlytics resource tasks. It validates actual generated project/sender/app resources, a Crashlytics mapping id, Turkish/quoted Android labels through AAPT2 and the ordinary demo resource build without Firebase configuration. It also signs a tiny synthetic native APK to verify the actual signature/package/version boundary, including rejection of unsigned, debuggable, wrong-version and foreign-package artifacts; its ephemeral test key is removed afterward. It builds/distributes no Flutter release and creates no Google resources. It removes its isolated source/build copy after success and retains small private diagnostics.


## Full tenant Flutter release probe without a cloud account

The separate `Verify real tenant Flutter release` GitHub workflow builds a complete ARM64 `tenant` release from the tracked checkout. It runs on mobile/tooling changes, or manually from Actions. No repository signing secret or Google account is required. Use the same command locally with Flutter 3.44.6, JDK 17, Android SDK build-tools 35.0.0 and at least **20 GiB** free for this probe's isolated Gradle cache:

```sh
python3 scripts/smoke_flutter_release.py --android-sdk /absolute/path/to/Android/sdk
# Preparation and disposable signing checks only, without a Flutter build:
python3 scripts/smoke_flutter_release.py --prepare-only
```

The probe uses synthetic tenant/Firebase identifiers and a fresh two-day RSA-3072 identity. It invokes the ordinary `mobile_android.build` release path, verifies the APK's actual package/version/non-debuggable flag, exact signing certificate and hash, checks the compiled ARM64 Flutter libraries, and checks generated Firebase/Crashlytics resources. Its own Gradle init script disables outbound Crashlytics upload tasks; normal production sources/configuration are not rewritten. It never invokes App Distribution or starts the application. This proves compilation/signing only after a successful run; it cannot establish a live crash report, tester installation or provider delivery.

Only ignored `.local/flutter-release-<id>/fixture.log`, public `result.json` and the public Gradle task audit remain. The isolated copied sources, Gradle cache, SDK export, signing key/password and APK are removed even on failure. The diagnostic artifact in CI includes only that synthetic build log. `--prepare-only` records `flutterReleaseBuilt=false` and is not evidence of a release build.


## Automatic Android publication from a SaaS subscription

Select `Provisioning:Mobile:Provider=AndroidAppDistribution` in **both** SaaS and the Portable worker. SaaS puts that explicit requirement in the durable tenant request. Local demo workers and workers with a different mobile policy reject it before resource work. New Android enrollment requires the updated PostgreSQL queue completion trigger: apply the current `Provisioning:InitializeSchema=true` initialization once with the schema owner before enabling the feature, then return runtime instances to `InitializeSchema=false`. Keep ordinary runtime roles separate from schema-owner credentials. An older worker's direct completion update is rejected when the required mobile checkpoint is absent. Legacy requests without this field remain equivalent to Disabled; their original JSON is not rewritten and they cannot silently acquire a signed/cloud release.

Merge [android-release.example.json](../infra/portable/android-release.example.json) into the private worker configuration; it is a configuration fragment. Keep `Provisioning:Profile=Portable`, enable the explicit Google provider/write options, supply its parent/deployment/ADC configuration and a writable AesGcm or optional Azure secret store. The sample deliberately leaves `AllowSigningKeyCreation` and `SharedArtifactsConfirmed` false: enable them only after preparing the worker's tools and shared private artifact storage. SaaS needs the provider selection and matching deployment id, not SDK paths or signing credentials.

The worker needs the pinned Flutter 3.44.6 revision, Python, JDK keytool, Android SDK platform android-35/build-tools 35.0.0, NDK and at least 15 GiB free for an actual Flutter build. Use absolute configured tool paths. Its working directory is private to that node and should reside on protected ephemeral/encrypted storage; all nodes must mount the same durable artifact directory at the configured path, with compatible owner permissions. Confirm backups and restore behavior before setting `SharedArtifactsConfirmed=true`. A missing/changed committed APK causes failure and is never silently replaced under the same initial app version.

Package the public mobile sources for a container or remote worker without copying Git metadata or authentication configuration:

```sh
python3 scripts/mobile_android.py --package-source "$PWD/.local/mobile-source-v1"
python3 .local/mobile-source-v1/scripts/mobile_android.py --source-hash
```

Set the worker's `SourceDirectory` to the mounted package root. Every file is verified against `mobile-source.json`; traversal, duplicate paths, generated SDK/signing files, symlinks and modified/missing source files are rejected. The packed checkout and original tracked sources produce the same fingerprint. The artifact can be mounted read-only; build workspaces and tenant SDK files are created separately. Keep this source package immutable while jobs using it are pending or running. An altered source fingerprint/version/target is rejected on retry, including attempts where all steps already have checkpoints. Drain in-flight jobs or retain their original worker/source configuration during upgrades; this initial-onboarding path does not implement later application upgrades.

After verified public tenant readiness, the automatic step:

1. Reads the canonical tenant Firebase configuration from the shared encrypted store and validates its package/project/app against the request and Google checkpoint. It constructs its build inputs from those owned backend values.
2. Generates one tenant-specific RSA-3072 PKCS12 keystore using JDK keytool. The encrypted `android-release-signing-v1` record contains its password, keystore, public certificate and tenant/package identity. Concurrent creators read the committed winner. Reads verify the saved alias/certificate without importing private keys into the OS keychain; missing/corrupt material is never silently rotated. Existing legacy `android-signing-key` values are neither imported nor rewritten.
3. Pins deployment, package, Firebase app, public store origin, source fingerprint, build number, signer fingerprint and artifact location in an immutable initial release plan. It builds the signed APK, then independently verifies package/version/signature/content before promotion.
4. Atomically promotes a content-addressed APK into the shared private tenant directory and selects one receipt through the central secret store. A restarted process verifies and reuses that exact APK, rather than compiling another binary for the same initial version.
5. Uses the existing ownership-checked App Distribution adapter and configured tenant tester group. Completed distribution is journaled; replay checks the remote project/release/build version using [the release API](https://firebase.google.com/docs/reference/app-distribution/rest/v1/projects.apps.releases/get) and does not re-upload or notify again in the normal completed-replay case. A crash between a provider side effect and saving its receipt can repeat that call; exact-once external delivery is not claimed. Firebase documents [identical-binary upload reuse](https://firebase.google.com/docs/reference/app-distribution/rest/v1/UploadReleaseResult).
6. Writes only public release/app ids, hashes and version information into `mobile-android-release`. The SaaS completion reconciler waits for all requested steps, including this one, before marking the business setup complete. The earlier tenant-ready outbox still describes store readiness; it is not evidence of email/device delivery.

Back up the encrypted secret database, its existing encryption master/key versions, the immutable source package and the private shared APK volume together. The same tenant keystore is required for later app updates; an App Distribution release alone is not a signing-key backup. Neither browsers, mobile manifests nor job status receive the private signing key/password.

Additional local acceptance probe (Docker, .NET 8, JDK and Android build-tools/platform required; it deliberately substitutes native fixture APK compilation and in-memory Google HTTP responses):

```sh
python3 scripts/smoke_android_release.py --android-sdk /absolute/path/to/Android/sdk --keytool /absolute/path/to/JDK/bin/keytool
```

It uses an isolated PostgreSQL container on loopback port 15441 and uniquely named test database. Real encrypted key storage, keytool/apksigner/AAPT2, short lease renewal, an upload failure, an independent process reading the key and a separate worker process completing the job are verified. It removes only that fixture's container, anonymous volume and temporary key/artifact files. No Azure account, live Google resources or Flutter compilation are required for this native workflow probe. See [VALIDATION.md](VALIDATION.md) for the exact evidence and remaining gates.

APK signing/verification tools are pinned to Android build-tools 35.0.0. Install that version even when Android Studio or a CI image includes newer SDK tools; a different command-output format is not silently adopted. Install platform android-35 for the native acceptance fixtures as well.
