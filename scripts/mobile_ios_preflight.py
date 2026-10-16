"""Check this Mac's local iOS release prerequisites without building or changing signing state."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import platform
import re
import shutil
import stat
import subprocess

ROOT = Path(__file__).resolve().parents[1]
FLUTTER_VERSION = "3.44.6"
MAX_CONFIG_BYTES = 65536


class CheckUnavailable(Exception):
    pass


def read_json(path, private=False):
    path = Path(path)
    if not path.is_absolute():
        raise ValueError("Configuration and SDK metadata paths must be absolute.")
    try:
        fd = os.open(path, os.O_RDONLY | getattr(os, "O_NOFOLLOW", 0) | getattr(os, "O_NONBLOCK", 0))
        with os.fdopen(fd, "rb") as source:
            info = os.fstat(source.fileno())
            if not stat.S_ISREG(info.st_mode) or info.st_size > MAX_CONFIG_BYTES:
                raise ValueError("Expected a bounded regular JSON file.")
            if private and (info.st_uid != os.getuid() or info.st_mode & 0o077):
                raise ValueError("Private configuration must be owned by the current user and accessible only to its owner (chmod 600).")
            payload = source.read(MAX_CONFIG_BYTES + 1)
        if len(payload) > MAX_CONFIG_BYTES:
            raise ValueError("JSON file is too large.")
        value = json.loads(payload)
    except (OSError, UnicodeError, json.JSONDecodeError):
        raise ValueError("Cannot read the selected JSON file; check its format, permissions and location.") from None
    if not isinstance(value, dict):
        raise ValueError("Expected a JSON object.")
    return value


def options(config=None):
    value = {}
    if config is not None:
        try:
            value = config["Provisioning"]["Mobile"]["Ios"]
        except (KeyError, TypeError):
            raise ValueError("Configuration must contain Provisioning:Mobile:Ios.") from None
        if not isinstance(value, dict):
            raise ValueError("Provisioning:Mobile:Ios must be an object.")
    if set(value) - {"DevelopmentTeam", "FlutterPath", "MinimumFreeGiB"}:
        raise ValueError("Unknown iOS preflight option.")
    team = value.get("DevelopmentTeam", "")
    flutter = value.get("FlutterPath", "")
    minimum = value.get("MinimumFreeGiB", 20)
    if not isinstance(team, str) or team and not re.fullmatch(r"[A-Z0-9]{10}", team):
        raise ValueError("DevelopmentTeam must be empty or an Apple Team ID with 10 uppercase letters/digits.")
    if not isinstance(flutter, str) or flutter and (not Path(flutter).is_absolute() or "\x00" in flutter):
        raise ValueError("FlutterPath must be empty or an absolute SDK bin/flutter path.")
    if type(minimum) is not int or not 20 <= minimum <= 1000:
        raise ValueError("MinimumFreeGiB must be an integer from 20 through 1000.")
    return {"DevelopmentTeam": team, "FlutterPath": flutter, "MinimumFreeGiB": minimum}


def command(args):
    try:
        result = subprocess.run(args, stdin=subprocess.DEVNULL, capture_output=True,
                                text=True, errors="replace", timeout=20, check=False)
    except subprocess.TimeoutExpired:
        raise CheckUnavailable("Local tool did not respond within 20 seconds.") from None
    except OSError:
        raise CheckUnavailable("Local tool could not be started.") from None
    if result.returncode:
        raise CheckUnavailable("Local tool could not complete the check.")
    return result.stdout


def flutter_version(executable):
    if not executable:
        raise CheckUnavailable("Install the pinned Flutter SDK or select its absolute bin/flutter path.")
    executable = Path(executable)
    if not executable.is_file() or not os.access(executable, os.X_OK):
        raise CheckUnavailable("The selected Flutter executable is unavailable.")
    executable = executable.resolve()
    if executable.name != "flutter" or executable.parent.name != "bin":
        raise CheckUnavailable("Select the real Flutter SDK bin/flutter executable instead of a version-manager shim.")
    sdk = executable.parent.parent
    try:
        metadata = sdk / "bin/cache/flutter.version.json"
        if metadata.exists():
            version = read_json(metadata).get("frameworkVersion", "")
        else:
            path = sdk / "version"
            if path.is_symlink() or not path.is_file() or path.stat().st_size > 256:
                raise ValueError("Missing SDK version metadata.")
            version = path.read_text().strip()
        if not isinstance(version, str) or not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+(?:[-+][A-Za-z0-9.-]+)?", version):
            raise ValueError("Invalid SDK version metadata.")
        return version
    except (ValueError, OSError, UnicodeError):
        raise CheckUnavailable("Cannot verify Flutter SDK metadata. Initialize the SDK separately; this check does not download SDK artifacts.") from None


def inspect(settings, work_directory=ROOT):
    checks = []

    def add(name, status, detail, **facts):
        checks.append(dict(name=name, status=status, detail=detail, **facts))

    def probe(name, callback):
        try:
            callback()
        except CheckUnavailable as error:
            add(name, "unavailable", str(error))

    is_mac = platform.system() == "Darwin"
    add("macOS", "passed" if is_mac else "failed", "iOS release builds require a Mac.")
    if is_mac:
        def xcode():
            output = command(["/usr/bin/xcodebuild", "-version"])
            match = re.search(r"^Xcode ([0-9]+(?:\.[0-9]+)*)$", output, re.MULTILINE)
            if not match:
                raise CheckUnavailable("Cannot identify the selected full Xcode installation.")
            add("Xcode", "passed", "Selected Xcode is available.", version=match.group(1))
        probe("Xcode", xcode)

        def first_launch():
            command(["/usr/bin/xcodebuild", "-checkFirstLaunchStatus"])
            add("Xcode first launch", "passed", "Xcode reports that its first-launch setup is complete.")
        probe("Xcode first launch", first_launch)

        def ios_sdk():
            version = command(["/usr/bin/xcrun", "--sdk", "iphoneos", "--show-sdk-version"]).strip()
            if not re.fullmatch(r"[0-9]+(?:\.[0-9]+)*", version):
                raise CheckUnavailable("Cannot identify the selected iPhoneOS SDK.")
            add("iPhoneOS SDK", "passed", "The device SDK is available.", version=version)
        probe("iPhoneOS SDK", ios_sdk)

        try:
            free = shutil.disk_usage(work_directory).free / 2**30
            minimum = settings["MinimumFreeGiB"]
            add("Free disk", "passed" if free >= minimum else "failed",
                "Measured on the selected build-work filesystem; the threshold is an operational guard, not an Apple specification.",
                freeGiB=round(free, 2), minimumGiB=minimum)
        except OSError:
            add("Free disk", "unavailable", "Cannot measure the selected build-work filesystem.")

        def flutter():
            version = flutter_version(settings["FlutterPath"] or shutil.which("flutter"))
            add("Flutter SDK", "passed" if version == FLUTTER_VERSION else "failed",
                "SDK version was read from local metadata without executing or bootstrapping Flutter.",
                version=version, requiredVersion=FLUTTER_VERSION)
        probe("Flutter SDK", flutter)
        pod = shutil.which("pod")
        add("CocoaPods", "passed" if pod and Path(pod).is_file() and os.access(pod, os.X_OK) else "failed",
            "CocoaPods must be installed and accessible to the Mac build user; dependency installation is not run by this check.")
        team = settings["DevelopmentTeam"]
        add("Apple Team", "passed" if team else "not-configured",
            "Select the Apple Developer Program team for tenant applications in the private configuration.")

        def signing():
            output = command(["/usr/bin/security", "find-identity", "-v", "-p", "codesigning"])
            identities = re.findall(r'^\s*\d+\)\s+[0-9A-Fa-f]{40}\s+"(?:Apple|iPhone) Distribution:[^"\r\n]* \(([A-Z0-9]{10})\)"\s*$', output, re.MULTILINE)
            matching = sum(value == team for value in identities) if team else 0
            add("Distribution signing", "not-configured" if not team else "passed" if matching else "failed",
                "A usable distribution identity for the selected team is required for the local signed IPA path. Certificate subjects and fingerprints are omitted.",
                validDistributionIdentityCount=len(identities), matchingTeamIdentityCount=matching)
        probe("Distribution signing", signing)

    return {"checkedAtUtc": datetime.now(timezone.utc).isoformat(),
            "scope": "Local prerequisites only; does not prove provisioning profiles, APNs, tenant configuration, IPA compilation, crash delivery or tester installation.",
            "readyForBuildAttempt": bool(checks) and all(x["status"] == "passed" for x in checks),
            "signedIpaBuilt": False, "distributed": False, "checks": checks}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, help="Absolute owner-only JSON with Provisioning:Mobile:Ios settings.")
    parser.add_argument("--work-directory", type=Path, default=ROOT, help="Existing absolute build-work directory; used only to measure its filesystem.")
    args = parser.parse_args(argv)
    try:
        settings = options(read_json(args.config, private=True) if args.config is not None else None)
        if not args.work_directory.is_absolute() or not args.work_directory.is_dir():
            raise ValueError("Build-work directory must be an existing absolute directory.")
        report = inspect(settings, args.work_directory)
    except ValueError as error:
        print(json.dumps({"error": str(error), "readyForBuildAttempt": False, "signedIpaBuilt": False, "distributed": False}))
        return 1
    print(json.dumps(report, indent=2))
    return 0 if report["readyForBuildAttempt"] else 2


if __name__ == "__main__":
    raise SystemExit(main())
