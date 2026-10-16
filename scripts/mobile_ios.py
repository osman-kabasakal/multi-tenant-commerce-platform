"""Prepare a tenant-owned Xcode workspace; optionally compile an unsigned device app on a Mac."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import plistlib
import re
import shutil
import subprocess
import sys
import uuid

import mobile_android as common
import mobile_ios_preflight as preflight
import mobile_ios_release as release

ROOT = Path(__file__).resolve().parents[1]
TOOLS = ("scripts/mobile_ios.py", "scripts/mobile_ios_project.rb", "scripts/mobile_ios_preflight.py", "scripts/mobile_ios_release.py", "scripts/mobile_ios_signing.rb")


def read_plist(path):
    path = Path(path)
    if path.is_symlink() or not path.is_file() or path.stat().st_size > common.MAX_CONFIG_BYTES:
        raise ValueError("Use a bounded regular Firebase SDK plist.")
    try:
        value = plistlib.loads(path.read_bytes())
    except (ValueError, plistlib.InvalidFileException):
        raise ValueError("Invalid Firebase SDK plist.") from None
    if not isinstance(value, dict):
        raise ValueError("Firebase SDK plist must contain a dictionary.")
    return value


def validate(manifest, client, android, ios, team, build_number):
    tenant = common.validate(manifest, client, android)
    bundle = client["iosBundleId"]
    extension = bundle + ".NotificationServiceExtension"
    if not isinstance(team, str) or not re.fullmatch(r"[A-Z0-9]{10}", team):
        raise ValueError("Select the ten-character Developer Portal Team ID.")
    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9-]*(?:\.[A-Za-z][A-Za-z0-9-]*)+", bundle) or len(extension) > 255:
        raise ValueError("Use an Apple bundle identifier without underscores and within Apple's length limit.")
    if type(build_number) is not int or not 1 <= build_number <= 2100000000:
        raise ValueError("Use a positive bounded iOS build number.")
    expected = {"PROJECT_ID": client["projectId"], "GCM_SENDER_ID": client["projectNumber"],
                "GOOGLE_APP_ID": client["iosAppId"], "BUNDLE_ID": bundle}
    if any(not isinstance(ios.get(key), str) or ios[key] != value for key, value in expected.items()):
        raise ValueError("Apple SDK configuration belongs to another tenant, project or Firebase app.")
    if not isinstance(ios.get("API_KEY"), str) or not ios["API_KEY"] or len(ios["API_KEY"]) > 256:
        raise ValueError("Apple SDK configuration requires its public API key.")
    if "$(" in tenant["displayName"] or "${" in tenant["displayName"]:
        raise ValueError("The iOS display name cannot contain Xcode setting substitutions.")
    return dict(tenant, iosBundleId=bundle, extensionBundleId=extension, developmentTeam=team, buildNumber=build_number)


def source_entries(root):
    entries = list(common.source_files(root))
    for name in TOOLS:
        source = root / name
        if source.is_symlink() or not source.is_file():
            raise ValueError("A required iOS build tool is missing or linked.")
        entries.append((source, name))
    return entries


def private_log(path):
    return os.fdopen(os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600), "w")


def prepare(manifest_path, firebase_directory, workspace, team, build_number=1, ruby="ruby", root=ROOT):
    firebase_directory = Path(firebase_directory)
    manifest = common.read_json(manifest_path)
    client = common.read_json(firebase_directory / "firebase-client.json")
    android = common.read_json(firebase_directory / "google-services.json")
    ios = read_plist(firebase_directory / "GoogleService-Info.plist")
    tenant = validate(manifest, client, android, ios, team, build_number)
    # Validate all inputs before common.prepare creates an isolated source copy.
    entries = source_entries(root)
    workspace, _ = common.prepare(manifest_path, firebase_directory, workspace, build_number, root)
    for name in TOOLS:
        destination = workspace / name
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(root / name, destination)
    tenant["sourceHash"] = common.hash_sources([(workspace / name, name) for _, name in entries])
    app = workspace / "Platforms/store_user_app"
    match = re.search(r"^version:\s*([0-9]+\.[0-9]+\.[0-9]+)(?:\+[0-9]+)?\s*$", (app / "pubspec.yaml").read_text(), re.MULTILINE)
    if not match:
        raise ValueError("Tracked pubspec must declare a supported iOS version.")
    tenant["buildName"] = match.group(1)
    tenant["iosSdkSha256"] = hashlib.sha256(plistlib.dumps(ios, sort_keys=True)).hexdigest()
    native = app / "ios"
    sdk = native / "Runner/GoogleService-Info.plist"
    sdk.write_bytes(plistlib.dumps(ios)); sdk.chmod(0o600)
    info = read_plist(native / "Runner/Info.plist")
    info["CFBundleDisplayName"] = tenant["displayName"]
    info["CFBundleName"] = "Runner"
    (native / "Runner/Info.plist").write_bytes(plistlib.dumps(info))
    (native / "Runner/Runner.entitlements").write_bytes(plistlib.dumps({"aps-environment": "production"}))
    common.private_json(workspace / "ios-tenant-build.json", tenant)
    with private_log(workspace / "ios-prepare.log") as log:
        common.run_private([ruby, str(workspace / "scripts/mobile_ios_project.rb"),
                            str(native), str(workspace / "ios-tenant-build.json")], workspace, os.environ.copy(), log, 60)
    common.private_json(workspace / "ios-result.json", dict(tenant, prepared=True, compiledIosApp=False,
                        signedIpaBuilt=False, distributed=False, symbolsUploaded=False))
    return workspace, tenant


def verify_compiled_app(binary, tenant):
    binary = Path(binary)
    if binary.is_symlink() or not binary.is_dir():
        raise ValueError("The unsigned device app is missing.")
    info = read_plist(binary / "Info.plist")
    if info.get("CFBundleIdentifier") != tenant["iosBundleId"] or info.get("CFBundleVersion") != str(tenant["buildNumber"]) or info.get("CFBundleShortVersionString") != tenant["buildName"]:
        raise ValueError("Compiled iOS identity or version differs from this tenant build.")
    ios = read_plist(binary / "GoogleService-Info.plist")
    expected = {"PROJECT_ID": tenant["projectId"], "GCM_SENDER_ID": tenant["projectNumber"],
                "GOOGLE_APP_ID": tenant["iosAppId"], "BUNDLE_ID": tenant["iosBundleId"]}
    if any(ios.get(key) != value for key, value in expected.items()):
        raise ValueError("Compiled Firebase configuration differs from this tenant build.")
    if hashlib.sha256(plistlib.dumps(ios, sort_keys=True)).hexdigest() != tenant.get("iosSdkSha256"):
        raise ValueError("Compiled Firebase SDK content differs from the owned export.")
    extension = binary / "PlugIns/NotificationServiceExtension.appex"
    extension_info = read_plist(extension / "Info.plist")
    if extension.is_symlink() or extension_info.get("CFBundleIdentifier") != tenant["extensionBundleId"] or extension_info.get("CFBundleVersion") != str(tenant["buildNumber"]) or extension_info.get("CFBundleShortVersionString") != tenant["buildName"]:
        raise ValueError("The tenant notification extension was not compiled correctly.")
    point = extension_info.get("NSExtension", {})
    if point.get("NSExtensionPointIdentifier") != "com.apple.usernotifications.service" or point.get("NSExtensionPrincipalClass") != "NotificationServiceExtension.NotificationService":
        raise ValueError("The compiled notification service entry point was not verified.")
    if info.get("CFBundleSupportedPlatforms") != ["iPhoneOS"]:
        raise ValueError("Expected an iPhone device application, not a Simulator bundle.")
    executable = binary / "Runner"
    if executable.is_symlink() or not executable.is_file() or not (binary / "Frameworks/App.framework/App").is_file():
        raise ValueError("The compiled native executable or Flutter release framework is missing.")
    architectures = subprocess.check_output(["/usr/bin/lipo", "-archs", str(executable)], text=True).strip().split()
    if architectures != ["arm64"]:
        raise ValueError("Expected an ARM64 device build.")
    build = subprocess.check_output(["/usr/bin/xcrun", "vtool", "-show-build", str(executable)], text=True)
    if len(re.findall(r"^\s*platform IOS\s*$", build, re.MULTILINE)) != 1:
        raise ValueError("The compiled ARM64 executable does not target iOS devices.")
    return dict(tenant, compiledIosApp=True, nativeExecutableSha256=common.file_hash(executable),
                signedIpaBuilt=False, distributed=False, symbolsUploaded=False)


def compile_unsigned(workspace, tenant, flutter, log):
    if platform.system() != "Darwin":
        raise ValueError("Device compilation requires macOS and full Xcode.")
    flutter = shutil.which(flutter) if not Path(flutter).is_absolute() else flutter
    if preflight.flutter_version(flutter) != preflight.FLUTTER_VERSION:
        raise ValueError("Use the repository's pinned Flutter SDK.")
    if shutil.disk_usage(workspace).free < 20 * 2**30:
        raise ValueError("The iOS compile probe requires at least 20 GiB free.")
    app = workspace / "Platforms/store_user_app"
    lock = app / "pubspec.lock"
    digest = common.file_hash(lock)
    environment = dict(os.environ, COCOAPODS_DISABLE_STATS="true", CI="true")
    commands = [[flutter, "pub", "get", "--enforce-lockfile"],
                [flutter, "build", "ios", "--release", "--no-codesign", "--flavor", "tenant",
                 "--build-name", tenant["buildName"], "--build-number", str(tenant["buildNumber"]),
                 "--dart-define-from-file=" + str(workspace / "tenant.defines.json")]]
    for command in commands:
        common.run_private(command, app, environment, log, 3600)
        if lock.is_symlink() or not lock.is_file() or common.file_hash(lock) != digest:
            raise ValueError("The iOS compile probe changed locked Dart dependencies.")
    return verify_compiled_app(app / "build/ios/iphoneos/Runner.app", tenant)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--firebase-directory", type=Path, required=True)
    parser.add_argument("--team", required=True, help="Ten-character Developer Portal Team ID; not the numeric App Store Connect team id.")
    parser.add_argument("--workspace", type=Path)
    parser.add_argument("--build-number", type=int, default=1)
    parser.add_argument("--ruby", default="ruby", help="Ruby with the pinned xcodeproj 1.27.0 gem.")
    parser.add_argument("--flutter", default="flutter")
    parser.add_argument("--compile-unsigned", action="store_true", help="Compile a device app for validation only; never sign, create an IPA or distribute.")
    parser.add_argument("--build-ipa", action="store_true", help="Archive/export a manually signed tenant IPA using installed identities and profiles.")
    parser.add_argument("--signing-config", type=Path, help="Absolute owner-only signing policy; required with --build-ipa.")
    parser.add_argument("--upload-symbols", action="store_true", help="Explicitly upload matching Crashlytics symbols after verified Xcode export.")
    parser.add_argument("--distribute-config", type=Path, help="Private Platform.Cloud settings; requires signed IPA, symbol upload and explicit provider writes.")
    args = parser.parse_args()
    if args.build_ipa and (args.compile_unsigned or not args.signing_config):
        parser.error("Choose --build-ipa with --signing-config, or --compile-unsigned.")
    if (args.signing_config or args.upload_symbols or args.distribute_config) and not args.build_ipa:
        parser.error("Signing/publication settings require --build-ipa.")
    if args.distribute_config and not args.upload_symbols:
        parser.error("Distribution requires --upload-symbols for the verified archive.")
    os.umask(0o077)
    try:
        workspace = args.workspace or ROOT / ".local/ios-builds" / uuid.uuid4().hex
        workspace, tenant = prepare(args.manifest, args.firebase_directory, workspace, args.team, args.build_number, args.ruby)
        if args.compile_unsigned:
            with private_log(workspace / "ios-build.log") as log:
                result = compile_unsigned(workspace, tenant, args.flutter, log)
            common.private_json(workspace / "ios-compile-result.json", result)
        if args.build_ipa:
            with private_log(workspace / "ios-release.log") as log:
                binary, result, settings = release.build(workspace, tenant, args.signing_config, args.ruby, args.flutter, log, compile_unsigned, verify_compiled_app)
                if args.distribute_config:
                    release.verify_distribution_target(workspace, tenant, args.distribute_config, log)
                    result["distributionTargetVerified"] = True
                if args.upload_symbols:
                    release.upload_symbols(workspace, binary, result, settings, log)
                if args.distribute_config:
                    if common.file_hash(binary) != result["ipaSha256"]:
                        raise ValueError("Verified IPA changed before distribution.")
                    common.run_private(["dotnet", "run", "--project", str(ROOT / "tools/Platform.Cloud"), "-c", "Release", "--", "distribute", "--config", str(args.distribute_config.absolute()), "--tenant", tenant["tenantId"], "--platform", "ios", "--binary", str(binary)], ROOT, os.environ.copy(), log, 1800)
                    result["distributed"] = True
            common.private_json(workspace / "ios-release-result.json", result)
        print(workspace)
        return 0
    except Exception as error:
        print("Tenant iOS operation failed (" + type(error).__name__ + "). Inspect the private workspace logs and configuration.", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
