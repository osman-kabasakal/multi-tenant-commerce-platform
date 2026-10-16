"""Native Mac worker operations; immutable inputs and each provider write are checked separately."""
import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import sys
import uuid

import mobile_ios as ios
import mobile_ios_preflight as preflight
import mobile_ios_release as release

PLAN_FIELDS = {"tenantId", "deploymentId", "iosBundleId", "developmentTeam", "signingCertificateSha256",
               "sourceHash", "buildNumber", "projectId", "projectNumber", "iosAppId", "firebaseSdkSha256", "storeUrl"}
EVIDENCE_FIELDS = ("ipaSha256", "signingCertificateSha256", "applicationProfileUuid", "extensionProfileUuid",
                   "symbolUuids", "symbolDwarfSha256", "iosSdkSha256", "nativeExecutableSha256", "iosPushTransport")


def read_plan(path):
    value = preflight.read_json(Path(path), private=True)
    if set(value) not in (PLAN_FIELDS, PLAN_FIELDS | {"iosPushTransport"}) or value.get("iosPushTransport", "Fcm") not in ("Fcm", "Apns") or any(not isinstance(value[name], str) or not value[name] for name in PLAN_FIELDS - {"buildNumber"}):
        raise ValueError("Expected the complete immutable iOS release plan.")
    if not re.fullmatch(r"[a-f0-9]{32}", value["tenantId"]) or int(value["tenantId"], 16) == 0:
        raise ValueError("Use a canonical nonempty tenant ID.")
    for name in ("sourceHash", "signingCertificateSha256", "firebaseSdkSha256"):
        if not re.fullmatch(r"[a-f0-9]{64}", value[name]):
            raise ValueError("Expected a SHA-256 release binding.")
    if type(value["buildNumber"]) is not int or not 1 <= value["buildNumber"] <= 2100000000:
        raise ValueError("Use a positive bounded build number.")
    return value


def bind(plan, tenant, firebase_directory):
    for name in ("tenantId", "iosBundleId", "developmentTeam", "sourceHash", "buildNumber", "projectId", "projectNumber", "iosAppId"):
        if tenant.get(name) != plan[name]:
            raise ValueError("Native iOS preparation differs from the immutable release plan.")
    if tenant.get("iosPushTransport", "Fcm") != plan.get("iosPushTransport", "Fcm") or (
        plan.get("iosPushTransport") == "Apns" and tenant.get("iosDevelopmentTeam") != plan["developmentTeam"]):
        raise ValueError("The native APNs transport or team differs from the immutable release plan.")
    if tenant.get("storeUrl", "").rstrip("/") != plan["storeUrl"].rstrip("/"):
        raise ValueError("The native build targets a different store origin.")
    # The queue binds the exact UTF-8 SDK export. Native verification independently canonicalizes its plist.
    raw = release.read_bytes((Path(firebase_directory) / "GoogleService-Info.plist").absolute(), private=True)
    if hashlib.sha256(raw).hexdigest() != plan["firebaseSdkSha256"]:
        raise ValueError("The SDK export changed after the iOS job was queued.")


def owned_path(workspace, relative, suffix, directory=False):
    if not isinstance(relative, str) or str(PurePosixPath(relative)) != relative or "\\" in relative:
        raise ValueError("Invalid relative native artifact path.")
    pieces = PurePosixPath(relative).parts
    if not pieces or PurePosixPath(relative).is_absolute() or any(x in (".", "..") for x in pieces):
        raise ValueError("The native artifact escaped its workspace.")
    path = Path(workspace).joinpath(*pieces)
    for parent in (path, *path.parents):
        if parent.is_symlink():
            raise ValueError("Native artifact paths cannot contain symbolic links.")
    if path.suffix != suffix or not (path.is_dir() if directory else path.is_file()):
        raise ValueError("The expected native artifact is missing.")
    return path


def build(args, plan):
    workspace, tenant = ios.prepare(args.manifest, args.firebase_directory, args.workspace,
                                     plan["developmentTeam"], plan["buildNumber"], args.ruby)
    bind(plan, tenant, args.firebase_directory)
    with ios.private_log(workspace / "ios-release.log") as log:
        _, result, _ = release.build(workspace, tenant, args.signing_config, args.ruby, args.flutter, log,
                                     ios.compile_unsigned, ios.verify_compiled_app,
                                     expected_certificate_sha256=plan["signingCertificateSha256"])
    result.update(deploymentId=plan["deploymentId"], firebaseSdkSha256=plan["firebaseSdkSha256"])
    ios.common.private_json(workspace / "ios-release-result.json", result)
    # No symbol/distribution upload happens before the parent stores this immutable artifact.
    return result


def verify(args, plan, upload=False):
    workspace = args.workspace
    tenant = preflight.read_json((workspace / "ios-tenant-build.json").absolute(), private=True)
    original = preflight.read_json((workspace / "ios-release-result.json").absolute(), private=True)
    bind(plan, tenant, args.firebase_directory)
    if any(original.get(flag) is not True for flag in ("signedIpaBuilt", "signatureVerified", "xcodeExported", "symbolsVerified")):
        raise ValueError("The retained artifact is not the result of a completed native export.")
    if original.get("deploymentId") != plan["deploymentId"] or original.get("firebaseSdkSha256") != plan["firebaseSdkSha256"]:
        raise ValueError("The retained native result belongs to another deployment or SDK export.")
    binary = owned_path(workspace, original.get("artifact"), ".ipa")
    archive = owned_path(workspace, original.get("archive"), ".xcarchive", directory=True)
    settings = release.policy(args.signing_config, tenant)
    native = release.signing_plan(settings, tenant, expected_certificate_sha256=plan["signingCertificateSha256"])
    verified = release.verify_ipa(binary, tenant, settings, native, ios.verify_compiled_app, archive)
    if any(verified.get(name) != original.get(name) for name in EVIDENCE_FIELDS):
        raise ValueError("The retained IPA, native metadata, profiles or matching symbols changed.")
    verified.update(xcodeExported=True, signedIpaBuilt=True)
    if upload:
        with ios.private_log(workspace / ("ios-symbols-" + uuid.uuid4().hex + ".log")) as log:
            release.upload_symbols(workspace, binary, verified, settings, log)
    return verified


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("source-hash")
    for name in ("build", "verify", "upload-symbols"):
        command = commands.add_parser(name)
        command.add_argument("--plan", type=Path, required=True)
        command.add_argument("--firebase-directory", type=Path, required=True)
        command.add_argument("--signing-config", type=Path, required=True)
        command.add_argument("--workspace", type=Path, required=True)
        if name == "build":
            command.add_argument("--manifest", type=Path, required=True)
            command.add_argument("--ruby", required=True)
            command.add_argument("--flutter", required=True)
    args = parser.parse_args(argv)
    os.umask(0o077)
    try:
        if args.command == "source-hash":
            print(ios.common.hash_sources(ios.source_entries(ios.ROOT)))
            return 0
        if not args.workspace.is_absolute() or not args.firebase_directory.is_absolute():
            raise ValueError("Use absolute private worker directories.")
        plan = read_plan(args.plan)
        result = build(args, plan) if args.command == "build" else verify(args, plan, args.command == "upload-symbols")
        print(json.dumps(result))
        return 0
    except Exception as error:
        print("Native iOS worker operation failed (" + type(error).__name__ + "). Inspect private diagnostics.", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
