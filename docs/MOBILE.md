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

`LOCAL_DEMO=true` is allowed only in debug builds. Firebase messaging/analytics/crash reporting and device integrity checks are skipped in that profile. Release signing is not configured. Customer-specific flavors, signing files and Firebase service configuration have been removed. Android cleartext access is enabled in the debug manifest only.

Validation on 2026-10-14: debug bundle and ARM64 APK compilation passed. On an API 36 ARM64 emulator, the app loaded the local catalog, opened Demo Espresso, added one item to the cart and displayed the $10.00 total. The web service's smoke checks also exercise guest tokens, catalogs and carts for both tenants. Static analysis reported no errors and 2,587 inherited warnings/information messages.

The demo uses `/TenantTokenWeb` for customer tokens, matching the server's tenant-specific signing keys. Notification polling and the optional slider plugin are skipped in the local profile. Product images use neutral placeholders. Full checkout, account registration, long-running token refresh, iOS, physical devices and release distribution remain unverified; see [VALIDATION.md](VALIDATION.md).

Compatibility references used for the dependency repair: [Skeletonizer changelog](https://pub.dev/packages/skeletonizer/changelog), [Google Fonts changelog](https://pub.dev/packages/google_fonts/changelog), [Android Gradle Plugin 8.9 compatibility](https://developer.android.com/build/releases/agp-8-9-0-release-notes). Dependencies are resolved in `pubspec.lock`.
