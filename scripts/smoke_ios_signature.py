"""Exercise real macOS signature checks with a disposable ad hoc signature, without an Apple certificate."""
import hashlib
import json
import os
from pathlib import Path
import platform
import plistlib
import subprocess
import tempfile
import uuid

import mobile_android as common
import mobile_ios_release as release

ROOT = Path(__file__).resolve().parents[1]


def main():
    if platform.system() != "Darwin":
        raise SystemExit("This native signature probe requires a Mac.")
    os.umask(0o077)
    parent = ROOT / ".local"; parent.mkdir(exist_ok=True)
    directory = parent / ("ios-signature-probe-" + uuid.uuid4().hex); directory.mkdir(mode=0o700)
    with tempfile.TemporaryDirectory(prefix="work-", dir=directory) as temporary:
        work = Path(temporary)
        app = work / "Probe.app"; app.mkdir()
        source = work / "main.c"; source.write_text("int main(void) { return 0; }\n")
        info = {"CFBundleIdentifier": "dev.commerce.signaturefixture", "CFBundleExecutable": "Probe", "CFBundleName": "Probe", "CFBundleVersion": "1", "CFBundlePackageType": "APPL", "CFBundleSupportedPlatforms": ["iPhoneOS"]}
        (app / "Info.plist").write_bytes(plistlib.dumps(info))
        (app / "embedded.mobileprovision").write_bytes(b"synthetic-profile-only-for-negative-test")
        entitlements = work / "entitlements.plist"; entitlements.write_bytes(plistlib.dumps({"get-task-allow": False}))
        log_path = directory / "fixture.log"
        with os.fdopen(os.open(log_path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600), "w") as log:
            sdk = release.apple(["/usr/bin/xcrun", "--sdk", "iphoneos", "--show-sdk-path"]).decode().strip()
            subprocess.run(["/usr/bin/xcrun", "--sdk", "iphoneos", "clang", "-target", "arm64-apple-ios13.0", "-isysroot", sdk, "-o", str(app / "Probe"), str(source)], check=True, stdout=log, stderr=subprocess.STDOUT)
            subprocess.run(["/usr/bin/codesign", "--force", "--sign", "-", "--entitlements", str(entitlements), str(app)], check=True, stdout=log, stderr=subprocess.STDOUT)
        build = release.apple(["/usr/bin/xcrun", "vtool", "-show-build", str(app / "Probe")]).decode()
        if "platform IOS" not in build or "IOSSIMULATOR" in build:
            raise ValueError("Native signature fixture does not target iOS devices.")
        release.uuids(app / "Probe")
        release.apple(["/usr/bin/codesign", "--verify", "--deep", "--strict", "--all-architectures", str(app)])
        parsed = plistlib.loads(release.apple(["/usr/bin/codesign", "--display", "--entitlements", "-", "--xml", str(app)]))
        if parsed.get("get-task-allow") is not False:
            raise ValueError("The actual Apple entitlement display did not return the expected plist.")
        profile = {"sha256": hashlib.sha256((app / "embedded.mobileprovision").read_bytes()).hexdigest(), "bundle": info["CFBundleIdentifier"]}
        try:
            release.check_signature(app, profile, {"DevelopmentTeam": "ABCDE12345"}, "0" * 64)
        except ValueError:
            rejected = True
        else:
            rejected = False
        if not rejected:
            raise ValueError("The non-Apple test signature passed the distribution trust gate.")
        result = {"realAdHocSignatureVerified": True, "realEntitlementXmlRead": True, "deviceMachPlatformVerified": True, "nativeSymbolUuidRead": True,
                  "nonAppleSignatureRejected": True, "appleDistributionPositiveVerified": False,
                  "signedIpaBuilt": False, "distributed": False}
        common.private_json(directory / "result.json", result)
        print(json.dumps({"diagnostics": str(directory), "result": result}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
