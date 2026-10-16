import argparse
import copy
import hashlib
import json
import plistlib
from datetime import datetime, timedelta, timezone
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import mobile_ios_worker as worker
import mobile_ios_release as release


class IosWorkerNativeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="ios-worker-contract-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.inputs = self.root / "inputs"; self.inputs.mkdir()
        self.sdk = self.inputs / "GoogleService-Info.plist"; self.sdk.write_bytes(b"synthetic-sdk-export"); self.sdk.chmod(0o600)
        self.plan = dict(tenantId="1" * 32, deploymentId="ios-contract", iosBundleId="dev.commerce.fixture",
                         developmentTeam="ABCDE12345", signingCertificateSha256="a" * 64, sourceHash="b" * 64,
                         buildNumber=7, projectId="ios-contract-demo", projectNumber="123456789",
                         iosAppId="1:123456789:ios:bbbbbbbb", firebaseSdkSha256=hashlib.sha256(self.sdk.read_bytes()).hexdigest(),
                         storeUrl="https://ios-coffee.example.test")
        self.tenant = dict(self.plan)
        self.workspace = self.root / "workspace"; self.workspace.mkdir()
        self.args = argparse.Namespace(manifest=self.root / "manifest.json", firebase_directory=self.inputs, workspace=self.workspace,
                                       ruby="ruby", flutter="flutter", signing_config=self.root / "signing.json")

    def private_json(self, name, value):
        path = self.root / name; path.write_text(json.dumps(value)); path.chmod(0o600); return path

    def test_complete_private_plan_is_required(self):
        path = self.private_json("plan.json", self.plan)
        self.assertEqual(worker.read_plan(path), self.plan)
        for change in ({"buildNumber": True}, {"sourceHash": "b" * 64 + "\n"}, {"tenantId": "0" * 32}, {"unknown": True}):
            value = dict(self.plan, **change); path.write_text(json.dumps(value))
            with self.subTest(fields=tuple(change)), self.assertRaises(ValueError): worker.read_plan(path)
        path.chmod(0o644)
        with self.assertRaises(ValueError): worker.read_plan(path)

    def test_native_preparation_and_exact_sdk_export_must_match_the_plan(self):
        worker.bind(self.plan, self.tenant, self.inputs)
        for name in ("tenantId", "iosBundleId", "developmentTeam", "sourceHash", "buildNumber", "projectId", "projectNumber", "iosAppId", "storeUrl"):
            changed = dict(self.tenant); changed[name] = "foreign"
            with self.subTest(field=name), self.assertRaises(ValueError): worker.bind(self.plan, changed, self.inputs)
        self.sdk.write_bytes(b"changed-export")
        with self.assertRaisesRegex(ValueError, "SDK export changed"): worker.bind(self.plan, self.tenant, self.inputs)

    def test_native_artifact_paths_cannot_escape_or_follow_links(self):
        binary = self.workspace / "release.ipa"; binary.write_bytes(b"synthetic")
        self.assertEqual(worker.owned_path(self.workspace, "release.ipa", ".ipa"), binary)
        outside = self.root / "outside.ipa"; outside.write_bytes(b"preserve")
        (self.workspace / "linked.ipa").symlink_to(outside)
        for name in ("../outside.ipa", str(outside), "linked.ipa", "a/../release.ipa", "release\\.ipa"):
            with self.subTest(path=name), self.assertRaises(ValueError): worker.owned_path(self.workspace, name, ".ipa")
        self.assertEqual(outside.read_bytes(), b"preserve")

    def test_profile_installation_is_atomic_idempotent_and_never_replaces_an_existing_uuid(self):
        profile = {"uuid": "11111111-1111-1111-1111-111111111111"}
        with patch.object(release.Path, "home", return_value=self.root):
            release.install_profile(profile, b"synthetic-cms")
            release.install_profile(profile, b"synthetic-cms")
            with self.assertRaisesRegex(ValueError, "preserved"): release.install_profile(profile, b"different-cms")
        installed = self.root / "Library/Developer/Xcode/UserData/Provisioning Profiles"
        self.assertEqual(len(list(installed.iterdir())), 1)
        path = next(installed.iterdir()); self.assertEqual(path.read_bytes(), b"synthetic-cms")
        self.assertEqual(path.stat().st_mode & 0o777, 0o600)

    def test_certificate_drift_stops_before_any_automatic_profile_installation(self):
        certificate = b"synthetic-certificate"
        selector = hashlib.sha1(certificate).hexdigest()
        settings = dict(DevelopmentTeam=self.plan["developmentTeam"], SigningCertificateSha1=selector,
                        RequiredDeviceUdids=["A" * 40], AllowProfileInstallation=True)
        profiles = {}
        for index, field in enumerate(("ApplicationProfile", "ExtensionProfile")):
            path = self.inputs / (field + ".mobileprovision"); path.write_bytes(b"synthetic-cms"); path.chmod(0o600)
            settings[field] = str(path)
            bundle = self.tenant["iosBundleId"] + (".NotificationServiceExtension" if index else "")
            value = dict(UUID=str(index + 1) * 8 + "-1111-1111-1111-111111111111", Platform=["iOS"],
                         TeamIdentifier=[settings["DevelopmentTeam"]], ApplicationIdentifierPrefix=[settings["DevelopmentTeam"]],
                         ExpirationDate=datetime.now(timezone.utc).replace(tzinfo=None) + timedelta(days=90), ProvisionedDevices=["A" * 40],
                         DeveloperCertificates=[certificate], Entitlements={"application-identifier": settings["DevelopmentTeam"] + "." + bundle,
                         "com.apple.developer.team-identifier": settings["DevelopmentTeam"], "get-task-allow": False, "aps-environment": "production"})
            profiles[str(path)] = plistlib.dumps(value)
        tenant = dict(self.tenant, extensionBundleId=self.tenant["iosBundleId"] + ".NotificationServiceExtension")
        def apple(args):
            if "find-identity" in args: return ('  1) ' + selector + ' "Apple Distribution: Synthetic (' + settings["DevelopmentTeam"] + ')"\n').encode()
            return profiles[args[-1]]
        with patch.object(release.platform, "system", return_value="Darwin"), patch.object(release, "apple", side_effect=apple), \
             patch.object(release, "install_profile") as installer:
            with self.assertRaisesRegex(ValueError, "immutable iOS release plan"):
                release.signing_plan(settings, tenant, expected_certificate_sha256="0" * 64)
            installer.assert_not_called()

    def test_profile_installer_will_not_follow_another_directory(self):
        outside = self.root / "outside"; outside.mkdir()
        (self.root / "Library").symlink_to(outside, target_is_directory=True)
        with patch.object(release.Path, "home", return_value=self.root), self.assertRaises(ValueError):
            release.install_profile({"uuid": "11111111-1111-1111-1111-111111111111"}, b"synthetic-cms")
        self.assertEqual(list(outside.iterdir()), [])

    def test_build_does_not_upload_before_the_artifact_journal_selects_a_winner(self):
        with patch.object(worker.ios, "prepare", return_value=(self.workspace, self.tenant)), \
             patch.object(worker.release, "build", return_value=(self.root / "native.ipa", {"ipaSha256": "c" * 64}, {})) as native, \
             patch.object(worker.release, "upload_symbols") as upload:
            result = worker.build(self.args, self.plan)
            self.assertEqual(result["firebaseSdkSha256"], self.plan["firebaseSdkSha256"])
            self.assertEqual(native.call_args.kwargs["expected_certificate_sha256"], self.plan["signingCertificateSha256"])
            upload.assert_not_called()
        self.assertTrue((self.workspace / "ios-release-result.json").is_file())

    def test_mismatched_native_source_stops_before_signing(self):
        changed = dict(self.tenant, sourceHash="d" * 64)
        with patch.object(worker.ios, "prepare", return_value=(self.workspace, changed)), patch.object(worker.release, "build") as native:
            with self.assertRaises(ValueError): worker.build(self.args, self.plan)
            native.assert_not_called()

    def test_changed_retained_symbol_evidence_cannot_reach_the_uploader(self):
        original = dict(self.tenant, signedIpaBuilt=True, signatureVerified=True, xcodeExported=True, symbolsVerified=True,
                        ipaSha256="c" * 64, artifact="native.ipa", archive="Runner.xcarchive",
                        applicationProfileUuid="11111111-1111-1111-1111-111111111111",
                        extensionProfileUuid="22222222-2222-2222-2222-222222222222", symbolUuids={}, symbolDwarfSha256={"Runner": "e" * 64})
        for name, value in (("ios-tenant-build.json", self.tenant), ("ios-release-result.json", original)):
            path = self.workspace / name; path.write_text(json.dumps(value)); path.chmod(0o600)
        (self.workspace / "native.ipa").write_bytes(b"synthetic")
        (self.workspace / "Runner.xcarchive").mkdir()
        changed = copy.deepcopy(original); changed["symbolDwarfSha256"]["Runner"] = "f" * 64
        with patch.object(worker.release, "policy", return_value={}), patch.object(worker.release, "signing_plan", return_value={}), \
             patch.object(worker.release, "verify_ipa", return_value=changed), patch.object(worker.release, "upload_symbols") as upload:
            with self.assertRaisesRegex(ValueError, "changed"): worker.verify(self.args, self.plan, upload=True)
            upload.assert_not_called()


if __name__ == "__main__": unittest.main()
