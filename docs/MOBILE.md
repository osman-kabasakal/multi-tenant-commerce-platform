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

The demo uses `/TenantTokenWeb` for customer tokens, matching the server's tenant-specific signing keys. Notification polling and the optional slider plugin are skipped in the local profile. Product images use neutral placeholders. Full checkout, account registration, long-running token refresh, signed iOS releases, physical devices and release distribution remain unverified; see [VALIDATION.md](VALIDATION.md).

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


## Prepare a Mac for tenant iOS releases

Linux cannot compile or sign an iOS IPA. Keep a Mac with full Xcode available for the iOS build worker; the Linux deployment still hosts the shared tenant services. The tenant Xcode preparation and unsigned compilation probe below are available. A separately configured manual-signing archive/export command is available below. Automatic Mac-worker scheduling and live iOS distribution remain unfinished; the Android pipeline does not verify them. The preparation command below only identifies local prerequisites and must not be interpreted as a completed mobile release.

Install the repository's pinned Flutter **3.44.6** SDK, CocoaPods and full Xcode. Open Xcode to finish its first-launch setup and accept the relevant terms yourself. In Xcode Settings > Accounts, add the Apple account with your Apple Developer Program membership. Find the Team ID in the membership details, and prepare a valid distribution signing identity for that team using Xcode's certificate management. An Apple ID or development certificate alone does not prove that an ad hoc distribution IPA can be signed. No certificate is created/imported/revoked by this repository's preparation check.

Copy [preflight.example.json](../infra/ios/preflight.example.json) to an absolute private location, set its permissions to `600`, and fill `Provisioning:Mobile:Ios:DevelopmentTeam` with the actual ten-character Team ID. Set `FlutterPath` to the actual SDK's absolute `bin/flutter` path when it is not on PATH or is selected by a version-manager shim. Do not put account passwords, signing keys or service-account JSON into this file or Git. These are preparation settings, not an enabled iOS provisioning provider.

```sh
python3 scripts/mobile_ios_preflight.py --config /absolute/private/ios-preflight.json \
  --work-directory /absolute/existing/ios-build-work
```

The build-work argument only selects the existing filesystem whose free space is measured; it creates no directory. It defaults to the repository directory. The operational guard is at least **20 GiB** free on that filesystem, configurable upward; SDK downloads and dependencies may need more. This is this project's initial safety margin, not an Apple minimum-storage specification. Unused Simulator runtimes can be removed through [Xcode's component management](https://developer.apple.com/documentation/xcode/downloading-and-installing-additional-xcode-components), preserving versions still needed for compatibility tests. Simulator runtimes are not the device SDK used to compile an IPA.

The command checks macOS, selected Xcode/first-launch completion, iPhoneOS SDK, free space, pinned Flutter SDK metadata, CocoaPods availability, selected team and matching local distribution identities. It does not execute Flutter or CocoaPods, download dependencies, accept licenses, import keys, change keychains, call Google/Apple cloud APIs or start a build. Certificate subjects/fingerprints and private configuration paths are omitted from the JSON output. Exit codes: `0` means the local checks passed, `2` means preparation gaps remain, and `1` means configuration could not be read/validated. `readyForBuildAttempt=true` is only permission to attempt a later build; `signedIpaBuilt` and `distributed` remain false.

A real tenant release must additionally bind the tenant's Firebase iOS app and bundle identifier, configure APNs delivery, provision the application/notification extension entitlements, sign and independently verify the IPA, upload the matching Crashlytics symbols and confirm App Distribution delivery. For ad hoc distribution, each tester device UDID must be in the signed provisioning profile; registering a later device requires updating the profile and distributing a newly signed IPA. See [Apple's registered-device distribution guide](https://developer.apple.com/documentation/xcode/distributing-your-app-to-registered-devices), [Firebase device registration](https://firebase.google.com/docs/app-distribution/register-additional-devices), and [Flutter iOS deployment](https://docs.flutter.dev/deployment/ios).

Cloud-free gate tests run on Linux without Apple executables, account access or signing keys:

```sh
python3 -m unittest discover -s scripts -p test_mobile_ios_preflight.py -v
```


## Tenant iOS native configuration and compilation probe

`scripts/mobile_ios.py` prepares a fresh isolated Xcode workspace from tracked mobile/module sources and the tenant Firebase export. It validates the iOS bundle/project/sender/app identity against the published manifest and Android export before creating that workspace. Apple bundle identifiers must not contain underscores. Supply the ten-character **Developer Portal Team ID**; the numeric App Store Connect team identifier is not a signing Team ID. The tool uses Ruby with `xcodeproj` **1.27.0** (provided by compatible CocoaPods installations, or install that exact gem separately).

Set `APPLE_DEVELOPER_TEAM_ID` to your actual team, then run:

```sh
python3 scripts/mobile_ios.py /absolute/private/mobile/TENANT_SLUG.json \
  --firebase-directory /absolute/private/firebase/BUSINESS_GUID_N \
  --team "$APPLE_DEVELOPER_TEAM_ID" --build-number 1
```

The generated `ios-tenant-build.json` binds the tenant, source fingerprint (including the iOS tools), native bundle/extension identifiers, Firebase app, version and signing team. `tenant.defines.json` contains matching public build identifiers. Only the isolated copy receives the Firebase plist as a Runner resource, the three `*-tenant` configurations, matching CocoaPods includes, the `tenant` scheme, and the embedded `NotificationServiceExtension` target. The production notification entitlement is written in that copy. That copy also selects CocoaPods for the pinned Flutter plugins so Firebase is not linked simultaneously through CocoaPods and Swift Package Manager. The project-scoped setting follows [Flutter’s documented override](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers#turn-off-swiftpm-for-a-single-project); user-wide Flutter settings and the tracked pubspec are unchanged. Re-evaluate the native dependency graph before upgrading the pinned SDK/plugins, as CocoaPods is in maintenance mode. No Apple portal object, signing key, provisioning profile or Google resource is created. Original project files are not rewritten by the preparation command.

To try a device compilation on a prepared Mac, append `--compile-unsigned --flutter /absolute/flutter/bin/flutter`. This restores the locked Dart dependencies, installs the native dependencies through Flutter, and compiles `--release --no-codesign --flavor tenant`. The resulting native bundle, build version, canonical Firebase SDK content hash, extension entry point and ARM64 executable with the iOS device Mach-O platform are checked before `ios-compile-result.json` can report `compiledIosApp=true`. It remains an **unsigned compilation check**: no usable signed IPA, distribution, symbol upload or device success is claimed. No application is launched and no Crashlytics upload phase is added. Logs stay in the private isolated workspace.

The Apple notification delegates now remain with FlutterFire and the notification plugins, preserving their consent and callback routing. The local demo entitlement file contains no legacy business domain. The rich-notification extension uses Firebase Messaging's documented service helper and guards against delivering completion twice when its time limit expires. Real APNs delivery still needs tenant Apple app/profile capabilities, APNs configuration in Firebase and physical-device evidence; the native source/graph check cannot prove that delivery.

A reproducible synthetic probe checks the actual Xcode graph on Linux or macOS using the pinned Ruby gem. The optional compilation requires a Mac, full Xcode, pinned Flutter/CocoaPods and at least 20 GiB free:

```sh
python3 -m unittest discover -s scripts -p 'test_mobile_ios*.py' -v
python3 scripts/smoke_mobile_ios.py
# Actual device compilation only, without signing or provider writes:
python3 scripts/smoke_mobile_ios.py --compile-unsigned --flutter /absolute/flutter/bin/flutter
```

The probe uses a synthetic team and unused Firebase identifiers. It retains only private logs and public verification metadata, deleting its own source copy, build output and Xcode DerivedData identified by that exact probe workspace even after failure. Other Xcode project caches are preserved. The normal tenant preparation command retains its workspace for inspection. Neither mode replaces positive signed-IPA verification with real Apple profiles, the shared Mac worker, App Distribution tester installation or Crashlytics symbol/report acceptance work. The native notification integration follows [Firebase's Flutter receive-message guide](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages).


The retained legacy Fastlane example reads `PRODUCE_APP_IDENTIFIER`, `FASTLANE_USER`, `APPLE_DEVELOPER_TEAM_ID` and `APP_STORE_CONNECT_TEAM_ID` from the operator environment. Historical TenantManager Apple automation also requires `APP_STORE_CONNECT_KEY_FILE` (absolute owner-only local `.p8`), `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, `APP_STORE_CONNECT_CONTACT_PHONE`, `APP_STORE_CONNECT_CONTACT_FIRST_NAME` and `APP_STORE_CONNECT_CONTACT_LAST_NAME`. Operator account identifiers, contact information and key identifiers are not source defaults. These historical examples are not the Portable iOS worker or evidence of automatic iOS distribution; the current tenant iOS preparation/compilation path uses the commands above and does not execute Fastlane or read Apple private keys.


## Tenant iOS signing and explicit delivery

The signed build command uses the selected Mac user's existing **Apple Distribution** identity and two installed **ad hoc** profiles. It does not create/import/revoke certificates, register devices, install profiles or call the Apple portal. Prepare an explicit App ID for the tenant bundle with Push Notifications enabled and another for its `.NotificationServiceExtension` bundle. Both profiles must authorize the same selected distribution certificate and all intended registered test devices. The extension profile must cover every device in the application profile. Install those exact profiles through Xcode, and keep owner-only copies at absolute private paths. The distribution certificate's private key must already be usable in that user's keychain.

Copy [signing.example.json](../infra/ios/signing.example.json) outside Git, set permissions to `600`, then set `AllowSigning=true`, the same ten-character `DevelopmentTeam`, the selected certificate's SHA-1 selector, both profile paths and `RequiredDeviceUdids`. The SHA-1 value selects an existing keychain identity; the exported certificate is independently compared using SHA-256. Keep device identifiers and profiles private. The flat signing file is separate from the nested preflight configuration.

```sh
python3 scripts/mobile_ios.py /absolute/private/mobile/TENANT_SLUG.json \
  --firebase-directory /absolute/private/firebase/BUSINESS_GUID_N \
  --team "$APPLE_DEVELOPER_TEAM_ID" --build-number 1 \
  --flutter /absolute/flutter/bin/flutter \
  --build-ipa --signing-config /absolute/private/ios-signing.json
```

The command validates profile expiry, team, explicit bundle, certificate, production push capability and registered devices before compiling. It binds the prepared application and extension to their own manual profiles, archives with Xcode, and exports using `release-testing` (the current Xcode method for ad hoc delivery). It supplies no `-allowProvisioningUpdates` option. The decoded CMS plist is a policy guard, not a claim to have independently validated Apple's profile signature or its modern DER payload; Xcode performs the archive/export profile validation. See [Apple's provisioning-profile explanation](https://developer.apple.com/documentation/technotes/tn3125-inside-code-signing-provisioning-profiles).

Before reporting success, the exported IPA must contain exactly the expected application and notification extension, matching tenant/version/Firebase configuration and an ARM64 device executable. Checks verify the actual Apple certificate chain requirement, signing team, selected leaf certificate, exact embedded profiles, permitted entitlements and production push entitlement. Runner and Flutter App binary UUIDs must match their archived dSYMs; those verified symbol bytes are hashed and checked again before upload. `ios-release-result.json` records hashes, profile UUIDs and separate verification/export/delivery flags only after each completed stage. Logs, archive, IPA and results stay in the private isolated workspace. A successful export does not establish physical-device installation or notification/crash delivery.

To submit the verified archive's symbols, set `AllowFirebaseWrites=true` in the signing file and append `--upload-symbols`. This explicitly invokes Firebase's installed `upload-symbols` tool against the unchanged tenant SDK plist and matching archive dSYMs, following [Firebase's symbol-upload instructions](https://firebase.google.com/docs/crashlytics/ios/get-deobfuscated-reports?platform=flutter). Successful tool completion records submission; a real crash must still appear with readable symbols in the tenant dashboard.

To also upload and distribute that same verified IPA, append `--distribute-config /absolute/private/platform-cloud.json` alongside `--upload-symbols`. Before any symbol/distribution write in this combined mode, Platform.Cloud re-exports the selected tenant’s encrypted Firebase record into the private workspace. Its tenant/project/app/bundle identifiers and canonical SDK hash must match the verified build. The existing [Platform.Cloud distribution command](../tools/Platform.Cloud/Program.cs) then requires explicitly enabled provider writes and configured tester groups. IPA hashing is checked again before submission. This is an explicit operator command; it is not yet connected to the SaaS subscription's durable mobile queue. An API upload/distribute success does not prove a tester installed the app. Adding a tester device later requires regenerated profiles and a newly signed build.

A separate native negative test runs without any Apple account or private signing key:

```sh
python3 scripts/smoke_ios_signature.py
```

On a Mac with Xcode it compiles a disposable iOS ARM64 executable, signs it ad hoc without a certificate, verifies its real Mach-O platform/UUID and entitlement XML, then confirms that this non-Apple signature fails the distribution trust requirement. CI runs this small probe on macOS and the actual Xcode target/profile-binding probe on Linux. Neither synthetic probe validates a positive Apple Distribution IPA.

## Apple account inputs for automatic tenant provisioning

Three account identifiers have different purposes: the **Developer Portal Team ID** is the ten-character signing team; the numeric **App Store Connect team ID** is used by retained legacy Fastlane account selection; the **Issuer ID** is the UUID paired with an App Store Connect API key. The numeric team ID cannot substitute for either of the others. No operator's account identifier is a tracked default.

For the planned automatic App ID/capability/profile stage, obtain an App Store Connect **team API key**. In App Store Connect, the Account Holder requests API access if it is not enabled. Then open **Users and Access > Integrations > App Store Connect API > Team Keys**, generate a key, record its **Key ID** and **Issuer ID**, and download its `.p8` file once to a private directory outside Git. Certificate management requires appropriate account permissions; Apple limits creating distribution certificates to the Account Holder or Admin. Choose permissions for the intended operations rather than assuming an App Manager key can create certificates. A team key applies across the account's applications. See [Apple's API-key setup](https://developer.apple.com/help/app-store-connect/get-started/app-store-connect-api) and [certificate roles](https://developer.apple.com/help/account/certificates/certificates-overview).

Supply only the local `.p8` file path, Key ID and Issuer ID when configuring the future provisioner; never put the key contents or account password in source, logs or chat. An App Store Connect API key authenticates portal API calls; it is not the distribution certificate/private key that signs the IPA and it is not an APNs authentication key. Automatic portal provisioning and shared Mac-worker scheduling remain unimplemented, and this document does not claim live portal access. Firebase APNs configuration and real device acceptance are additional prerequisites for working notifications.
