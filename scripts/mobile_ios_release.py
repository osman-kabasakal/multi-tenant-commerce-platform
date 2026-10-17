"""Build/export with Xcode and check tenant identity, signatures, profiles and symbols before publication.

Profile plist fields are diagnostic guards. Xcode archive/export validates Apple's
profile format; CMS decoding alone is not a profile trust decision (Apple TN3125).
"""
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import platform
import plistlib
import re
import shutil
import stat
import subprocess
import tempfile
import unicodedata
import uuid
import zipfile

import mobile_android as common
import mobile_ios_preflight as preflight


PROFILE_LIMIT = 2 * 1024**2
SYMBOL_BUNDLES = (("Runner", "Runner", "Runner.app.dSYM"), ("App", "Frameworks/App.framework/App", "App.framework.dSYM"))


def read_bytes(path, private=False, limit=PROFILE_LIMIT):
    path = Path(path)
    if not path.is_absolute():
        raise ValueError("Signing inputs must use absolute file paths.")
    fd = os.open(path, os.O_RDONLY | getattr(os, "O_NOFOLLOW", 0) | getattr(os, "O_NONBLOCK", 0))
    with os.fdopen(fd, "rb") as source:
        info = os.fstat(source.fileno())
        if not stat.S_ISREG(info.st_mode) or info.st_size > limit:
            raise ValueError("Use a bounded regular signing input.")
        if private and (info.st_uid != os.getuid() or info.st_mode & 0o077):
            raise ValueError("Private signing inputs must be owned by the build user and accessible only to their owner.")
        data = source.read(limit + 1)
    if len(data) > limit:
        raise ValueError("Signing input is too large.")
    return data


def policy(path, tenant):
    value = preflight.read_json(Path(path), private=True)
    allowed = {"AllowSigning", "AllowFirebaseWrites", "AllowProfileInstallation", "DevelopmentTeam", "SigningCertificateSha1", "ApplicationProfile", "ExtensionProfile", "RequiredDeviceUdids"}
    if set(value) - allowed or value.get("AllowSigning") is not True:
        raise ValueError("Signing requires explicit AllowSigning and supported release settings.")
    if value.get("DevelopmentTeam") != tenant["developmentTeam"] or not re.fullmatch(r"[A-Z0-9]{10}", value.get("DevelopmentTeam", "")):
        raise ValueError("Signing policy belongs to another Apple team.")
    if not isinstance(value.get("SigningCertificateSha1"), str) or not re.fullmatch(r"[0-9A-Fa-f]{40}", value["SigningCertificateSha1"]):
        raise ValueError("Select the existing distribution certificate by its SHA-1 keychain selector.")
    if any(type(value.get(name, False)) is not bool for name in ("AllowFirebaseWrites", "AllowProfileInstallation")):
        raise ValueError("Firebase writes and profile installation must be explicit booleans.")
    value["RequiredDeviceUdids"] = devices(value.get("RequiredDeviceUdids"))
    value["SigningCertificateSha1"] = value["SigningCertificateSha1"].lower()
    for name in ["ApplicationProfile", "ExtensionProfile"]:
        path = value.get(name)
        if not isinstance(path, str) or not Path(path).is_absolute():
            raise ValueError("Supply absolute private application and extension provisioning-profile paths.")
        read_bytes(path, private=True)
    return value


def devices(value):
    if not isinstance(value, list) or not 1 <= len(value) <= 1000:
        raise ValueError("Select a bounded nonempty set of registered test-device UDIDs.")
    if any(not isinstance(x, str) or not re.fullmatch(r"(?:[0-9A-Fa-f]{40}|[0-9A-Fa-f]{8}-[0-9A-Fa-f]{16})", x) for x in value):
        raise ValueError("Invalid test-device UDID format.")
    result = [x.upper() for x in value]
    if len(set(result)) != len(result):
        raise ValueError("Duplicate test-device UDIDs are not allowed.")
    return result


def apple(args, limit=8 * 1024**2):
    try:
        result = subprocess.run(args, stdin=subprocess.DEVNULL, capture_output=True, timeout=45)
    except (OSError, subprocess.TimeoutExpired):
        raise ValueError("An Apple signing check could not complete.") from None
    if result.returncode or len(result.stdout) > limit:
        raise ValueError("An Apple signing check failed; inspect the private build configuration.")
    return result.stdout


def profile_guard(value, bundle, settings, application, now=None):
    now = now or datetime.now(timezone.utc)
    if not isinstance(value, dict):
        raise ValueError("Expected a decoded provisioning-profile dictionary.")
    expiry = value.get("ExpirationDate")
    if not isinstance(expiry, datetime) or expiry.replace(tzinfo=timezone.utc) <= now:
        raise ValueError("Provisioning profile is expired or has no valid expiry.")
    # Current Apple iOS profiles also list the visionOS platform aliases.
    platforms = value.get("Platform")
    if (not isinstance(platforms, list) or "iOS" not in platforms or
            any(not isinstance(item, str) or item not in ("iOS", "xrOS", "visionOS") for item in platforms) or
            len(platforms) != len(set(platforms)) or value.get("ProvisionsAllDevices", False) is not False or
            value.get("TeamIdentifier") != [settings["DevelopmentTeam"]]):
        raise ValueError("Use an iOS ad hoc profile belonging to the selected team.")
    try:
        profile_id = str(uuid.UUID(value.get("UUID", "")))
    except (ValueError, AttributeError, TypeError):
        raise ValueError("Provisioning profile has no valid UUID.") from None
    if profile_id == str(uuid.UUID(int=0)):
        raise ValueError("Provisioning profile UUID cannot be empty.")
    entitlements = value.get("Entitlements", {})
    prefixes = value.get("ApplicationIdentifierPrefix", [])
    if not isinstance(prefixes, list) or len(prefixes) != 1 or not isinstance(prefixes[0], str) or not re.fullmatch(r"[A-Z0-9]{10}", prefixes[0]):
        raise ValueError("Provisioning profile has no supported App ID prefix.")
    if not isinstance(entitlements, dict) or entitlements.get("application-identifier") != prefixes[0] + "." + bundle or entitlements.get("com.apple.developer.team-identifier") != settings["DevelopmentTeam"] or entitlements.get("get-task-allow") is not False:
        raise ValueError("Profile bundle identity or distribution entitlement differs from the tenant.")
    if application and entitlements.get("aps-environment") != "production":
        raise ValueError("The application profile must authorize production APNs.")
    registered = devices(value.get("ProvisionedDevices"))
    if not set(settings["RequiredDeviceUdids"]).issubset(registered):
        raise ValueError("A required tester device is absent from the profile.")
    certificates = value.get("DeveloperCertificates", [])
    if not isinstance(certificates, list) or not 1 <= len(certificates) <= 16:
        raise ValueError("Provisioning profile has no bounded certificate set.")
    matches = [x for x in certificates if isinstance(x, bytes) and len(x) <= 65536 and hashlib.sha1(x).hexdigest() == settings["SigningCertificateSha1"]]
    if len(matches) != 1:
        raise ValueError("The selected signing certificate is not uniquely authorized by the profile.")
    # Xcode matches a UUID selector case-sensitively. Preserve the signed CMS spelling.
    return {"uuid": value["UUID"], "entitlements": entitlements, "certificate": matches[0],
            "expiresAtUtc": expiry.replace(tzinfo=timezone.utc).isoformat(), "deviceCount": len(registered), "devices": registered, "application": application}


def install_profile(profile, raw):
    """Add only a new UUID-named profile; never replace another Xcode profile."""
    directory = Path.home() / "Library/Developer/Xcode/UserData/Provisioning Profiles"
    for parent in (directory, *directory.parents):
        if parent.is_symlink():
            raise ValueError("Profile installation cannot follow symbolic links.")
    directory.mkdir(parents=True, exist_ok=True, mode=0o700)
    profile_id = profile["uuid"]
    if not isinstance(profile_id, str) or not re.fullmatch(r"[0-9A-Fa-f]{8}(?:-[0-9A-Fa-f]{4}){3}-[0-9A-Fa-f]{12}", profile_id):
        raise ValueError("Use the exact signed profile UUID.")
    target = directory / (profile_id + ".mobileprovision")
    temporary = directory / (".platform-profile-" + uuid.uuid4().hex)
    try:
        fd = os.open(temporary, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        with os.fdopen(fd, "wb") as output:
            output.write(raw); output.flush(); os.fsync(output.fileno())
        try:
            os.link(temporary, target, follow_symlinks=False)
        except FileExistsError:
            if read_bytes(target, private=True) != raw:
                raise ValueError("An existing Xcode profile with this UUID has different bytes; it was preserved.") from None
    finally:
        temporary.unlink(missing_ok=True)


def signing_plan(settings, tenant, expected_certificate_sha256=None):
    if platform.system() != "Darwin":
        raise ValueError("Signed IPA production requires macOS and Xcode.")
    identity = apple(["/usr/bin/security", "find-identity", "-v", "-p", "codesigning"]).decode(errors="replace")
    identities = re.findall(r'^\s*\d+\)\s+([0-9A-Fa-f]{40})\s+"(?:Apple|iPhone) Distribution:[^"\r\n]* \(([A-Z0-9]{10})\)"\s*$', identity, re.MULTILINE)
    if (settings["SigningCertificateSha1"], settings["DevelopmentTeam"]) not in [(a.lower(), b) for a, b in identities]:
        raise ValueError("The configured distribution identity is not available to the Mac build user.")
    result = {}
    for kind, field, bundle in [("application", "ApplicationProfile", tenant["iosBundleId"]), ("extension", "ExtensionProfile", tenant["extensionBundleId"])]:
        raw = read_bytes(settings[field], private=True)
        decoded = plistlib.loads(apple(["/usr/bin/security", "cms", "-D", "-i", settings[field]]))
        value = profile_guard(decoded, bundle, settings, kind == "application")
        value.update(raw=raw, sha256=hashlib.sha256(raw).hexdigest(), bundle=bundle)
        result[kind] = value
    if result["application"]["certificate"] != result["extension"]["certificate"]:
        raise ValueError("The application and extension profiles authorize different signing certificates.")
    if not set(result["application"]["devices"]).issubset(result["extension"]["devices"]):
        raise ValueError("The extension profile does not cover every application-profile device.")
    result["certificateSha256"] = hashlib.sha256(result["application"]["certificate"]).hexdigest()
    if expected_certificate_sha256 is not None and result["certificateSha256"] != expected_certificate_sha256:
        raise ValueError("The native signing certificate differs from the immutable iOS release plan.")
    for value in result.values():
        if not isinstance(value, dict):
            continue
        if settings.get("AllowProfileInstallation") is True:
            install_profile(value, value["raw"])
        installed = [Path.home() / "Library/MobileDevice/Provisioning Profiles", Path.home() / "Library/Developer/Xcode/UserData/Provisioning Profiles"]
        if not any((directory / (value["uuid"] + ".mobileprovision")).is_file() and read_bytes(directory / (value["uuid"] + ".mobileprovision")) == value["raw"] for directory in installed):
            raise ValueError("Install the exact selected profiles in Xcode before this manual-signing build.")
    return result


def authorize(actual, allowed):
    if isinstance(actual, str) and isinstance(allowed, str):
        return re.fullmatch(re.escape(allowed).replace(r"\*", ".*"), actual) is not None
    if isinstance(actual, list) and isinstance(allowed, list):
        return all(any(authorize(x, y) for y in allowed) for x in actual)
    if isinstance(actual, dict) and isinstance(allowed, dict):
        return all(key in allowed and authorize(value, allowed[key]) for key, value in actual.items())
    return type(actual) is type(allowed) and actual == allowed


def check_signature(app, profile, settings, certificate_sha256):
    embedded = read_bytes((app / "embedded.mobileprovision").absolute())
    if hashlib.sha256(embedded).hexdigest() != profile["sha256"]:
        raise ValueError("The exported app embedded a different provisioning profile.")
    requirement = 'anchor apple generic and certificate leaf[subject.OU] = "' + settings["DevelopmentTeam"] + '" and identifier "' + profile["bundle"] + '"'
    apple(["/usr/bin/codesign", "--verify", "--strict", "--all-architectures", "-R", requirement, str(app)])
    entitlements = plistlib.loads(apple(["/usr/bin/codesign", "--display", "--entitlements", "-", "--xml", str(app)]))
    if not isinstance(entitlements, dict) or entitlements.get("application-identifier") != profile["entitlements"]["application-identifier"] or entitlements.get("com.apple.developer.team-identifier") != settings["DevelopmentTeam"] or entitlements.get("get-task-allow", False) is not False or not authorize(entitlements, profile["entitlements"]):
        raise ValueError("Signed entitlements exceed the selected tenant profile.")
    if profile.get("application") and entitlements.get("aps-environment") != "production":
        raise ValueError("The signed application is missing its production push entitlement.")
    with tempfile.TemporaryDirectory(prefix="ios-signature-") as directory:
        prefix = Path(directory) / "cert"
        apple(["/usr/bin/codesign", "--display", "--extract-certificates=" + str(prefix), str(app)])
        leaf = read_bytes(Path(str(prefix) + "0"), limit=65536)
        if hashlib.sha256(leaf).hexdigest() != certificate_sha256:
            raise ValueError("The exported app uses a different signing certificate.")


def unpack_ipa(binary, destination):
    """Validate the complete member table before writing any untrusted archive path."""
    if Path(binary).is_symlink() or not Path(binary).is_file() or Path(binary).stat().st_size > 1024**3:
        raise ValueError("Use a bounded regular IPA.")
    with zipfile.ZipFile(binary) as archive:
        members = archive.infolist()
        if not 1 <= len(members) <= 30000 or sum(x.file_size for x in members) > 2 * 1024**3:
            raise ValueError("IPA expansion exceeds the supported bounds.")
        seen = set()
        for entry in members:
            name = entry.filename.rstrip("/")
            path = PurePosixPath(name)
            normalized = unicodedata.normalize("NFC", name).casefold()
            mode = entry.external_attr >> 16
            if not name or entry.orig_filename != entry.filename or str(path) != name or path.is_absolute() or any(x in (".", "..") for x in path.parts) or "\\" in name or any(ord(x) < 32 for x in name) or normalized in seen or entry.flag_bits & 1 or entry.file_size > 512 * 1024**2 or stat.S_IFMT(mode) not in (0, stat.S_IFREG, stat.S_IFDIR):
                raise ValueError("Unsafe or ambiguous IPA archive member.")
            seen.add(normalized)
            if path.parts[0] not in ("Payload", "SwiftSupport", "Symbols", "BCSymbolMaps"):
                raise ValueError("IPA contains files outside the supported Xcode export layout.")
            if path.parts[0] == "Payload" and (len(path.parts) > 1 and path.parts[1] != "Runner.app"):
                raise ValueError("IPA contains an unexpected application payload.")
        for entry in members:
            target = destination.joinpath(*PurePosixPath(entry.filename.rstrip("/")).parts)
            if entry.is_dir():
                target.mkdir(parents=True, exist_ok=True, mode=0o700)
            else:
                target.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
                with archive.open(entry) as source, target.open("xb") as output:
                    shutil.copyfileobj(source, output)
                target.chmod(0o700 if entry.external_attr >> 16 & 0o111 else 0o600)
    return destination / "Payload/Runner.app"


def uuids(binary):
    output = apple(["/usr/bin/xcrun", "dwarfdump", "--uuid", str(binary)]).decode(errors="replace")
    matches = re.findall(r"^UUID: ([0-9A-Fa-f-]{36}) \(([^)]+)\)", output, re.MULTILINE)
    if len(matches) != 1 or matches[0][1] != "arm64":
        raise ValueError("Expected a single ARM64 symbol UUID.")
    return str(uuid.UUID(matches[0][0])).lower()


def verify_symbols(app, archive):
    symbols, hashes = {}, {}
    for label, relative, dsym in SYMBOL_BUNDLES:
        executable = app / relative
        dwarf = archive / "dSYMs" / dsym / "Contents/Resources/DWARF" / label
        if dwarf.is_symlink() or not dwarf.is_file():
            raise ValueError("The archived Crashlytics symbols are missing.")
        binary_uuid, symbol_uuid = uuids(executable), uuids(dwarf)
        if binary_uuid != symbol_uuid:
            raise ValueError("The exported app does not match its archived Crashlytics symbols.")
        symbols[label] = symbol_uuid
        hashes[label] = common.file_hash(dwarf)
    return symbols, hashes


def verify_ipa(binary, tenant, settings, plan, verify_native, archive):
    with tempfile.TemporaryDirectory(prefix="ios-ipa-") as directory:
        app = unpack_ipa(binary, Path(directory))
        result = verify_native(app, tenant)
        apple(["/usr/bin/codesign", "--verify", "--deep", "--strict", "--all-architectures", str(app)])
        if sorted(x.name for x in (app / "PlugIns").iterdir()) != ["NotificationServiceExtension.appex"]:
            raise ValueError("IPA contains unexpected app extensions.")
        check_signature(app, plan["application"], settings, plan["certificateSha256"])
        check_signature(app / "PlugIns/NotificationServiceExtension.appex", plan["extension"], settings, plan["certificateSha256"])
        symbols, symbol_hashes = verify_symbols(app, archive)
    return dict(result, signatureVerified=True, signedIpaBuilt=False, xcodeExported=False, deviceInstallationVerified=False,
                ipaSha256=common.file_hash(Path(binary)), signingCertificateSha256=plan["certificateSha256"],
                applicationProfileUuid=plan["application"]["uuid"], extensionProfileUuid=plan["extension"]["uuid"],
                symbolUuids=symbols, symbolDwarfSha256=symbol_hashes, symbolsVerified=True, symbolsUploaded=False, distributed=False)


def build(workspace, tenant, signing_file, ruby, flutter, log, compile_native, verify_native, expected_certificate_sha256=None):
    settings = policy(signing_file, tenant)
    plan = signing_plan(settings, tenant, expected_certificate_sha256) if expected_certificate_sha256 is not None else signing_plan(settings, tenant)
    compile_native(workspace, tenant, flutter, log)
    app = workspace / "Platforms/store_user_app"
    private = workspace / "ios-release"; private.mkdir(mode=0o700)
    archive = private / "Runner.xcarchive"
    export = private / "export"
    public_plan = {"developmentTeam": settings["DevelopmentTeam"], "certificateSha1": settings["SigningCertificateSha1"],
                   "application": {"bundle": tenant["iosBundleId"], "uuid": plan["application"]["uuid"]},
                   "extension": {"bundle": tenant["extensionBundleId"], "uuid": plan["extension"]["uuid"]}}
    common.private_json(workspace / "ios-signing-plan.json", public_plan)
    common.run_private([ruby, str(workspace / "scripts/mobile_ios_signing.rb"), str(workspace)], workspace, os.environ.copy(), log, 60)
    options = {"method": "release-testing", "destination": "export", "signingStyle": "manual", "teamID": settings["DevelopmentTeam"],
               "signingCertificate": settings["SigningCertificateSha1"], "manageAppVersionAndBuildNumber": False,
               "provisioningProfiles": {plan[k]["bundle"]: plan[k]["uuid"] for k in ("application", "extension")}}
    options_path = private / "ExportOptions.plist"
    with os.fdopen(os.open(options_path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600), "wb") as output:
        plistlib.dump(options, output)
    environment = dict(os.environ, COCOAPODS_DISABLE_STATS="true", CI="true")
    commands = [["/usr/bin/xcodebuild", "-workspace", str(app / "ios/Runner.xcworkspace"), "-scheme", "tenant", "-configuration", "Release-tenant",
                 "-sdk", "iphoneos", "-destination", "generic/platform=iOS", "-archivePath", str(archive), "-derivedDataPath", str(private / "DerivedData"),
                 "CODE_SIGN_IDENTITY=" + settings["SigningCertificateSha1"], "DEVELOPMENT_TEAM=" + settings["DevelopmentTeam"], "archive"],
                ["/usr/bin/xcodebuild", "-exportArchive", "-archivePath", str(archive), "-exportPath", str(export), "-exportOptionsPlist", str(options_path)]]
    for command in commands:
        common.run_private(command, app, environment, log, 3600)
    binaries = list(export.glob("*.ipa"))
    if len(binaries) != 1:
        raise ValueError("Xcode did not export one tenant IPA.")
    result = verify_ipa(binaries[0], tenant, settings, plan, verify_native, archive)
    result.update(signedIpaBuilt=True, xcodeExported=True)
    result["artifact"] = str(binaries[0].relative_to(workspace))
    result["archive"] = str(archive.relative_to(workspace))
    return binaries[0], result, settings


def verify_distribution_target(workspace, tenant, config, log):
    config = Path(config).absolute()
    preflight.read_json(config, private=True)
    directory = workspace / "ios-distribution-target"; directory.mkdir(mode=0o700)
    # Re-read the selected tenant's authoritative encrypted configuration before any Firebase write.
    common.run_private(["dotnet", "run", "--project", str(common.ROOT / "tools/Platform.Cloud"), "-c", "Release", "--", "export-mobile",
                        "--config", str(config), "--tenant", tenant["tenantId"], "--output", str(directory)], common.ROOT, os.environ.copy(), log, 1800)
    client = common.read_json(directory / "firebase-client.json")
    if any(client.get(name) != tenant[name] for name in ["tenantId", "projectId", "projectNumber", "iosAppId", "iosBundleId"]):
        raise ValueError("The verified iOS build differs from the tenant's stored Firebase identity.")
    sdk = plistlib.loads(read_bytes((directory / "GoogleService-Info.plist").absolute(), private=True))
    if hashlib.sha256(plistlib.dumps(sdk, sort_keys=True)).hexdigest() != tenant["iosSdkSha256"]:
        raise ValueError("The verified iOS SDK differs from the tenant's stored Firebase configuration.")


def upload_symbols(workspace, binary, result, settings, log):
    if settings.get("AllowFirebaseWrites") is not True or not result.get("symbolsVerified") or not result.get("xcodeExported") or common.file_hash(Path(binary)) != result.get("ipaSha256"):
        raise ValueError("Symbol upload requires explicit Firebase writes and the unchanged verified Xcode export.")
    app = workspace / "Platforms/store_user_app"
    uploader = app / "ios/Pods/FirebaseCrashlytics/upload-symbols"
    if uploader.is_symlink() or not uploader.is_file():
        raise ValueError("The installed Firebase Crashlytics symbol uploader is missing.")
    sdk = plistlib.loads(read_bytes((app / "ios/Runner/GoogleService-Info.plist").absolute()))
    if hashlib.sha256(plistlib.dumps(sdk, sort_keys=True)).hexdigest() != result.get("iosSdkSha256"):
        raise ValueError("The Firebase SDK input changed before symbol upload.")
    for label, _, dsym in SYMBOL_BUNDLES:
        dwarf = workspace / "ios-release/Runner.xcarchive/dSYMs" / dsym / "Contents/Resources/DWARF" / label
        if dwarf.is_symlink() or not dwarf.is_file() or common.file_hash(dwarf) != result.get("symbolDwarfSha256", {}).get(label):
            raise ValueError("The verified application symbols changed before upload.")
    # This is an explicit network-write stage, never part of unsigned probes.
    common.run_private([str(uploader), "-gsp", str(app / "ios/Runner/GoogleService-Info.plist"), "-p", "ios", str(workspace / "ios-release/Runner.xcarchive/dSYMs")],
                       app, os.environ.copy(), log, 1800)
    result["symbolsUploaded"] = True
