"""Test cross-tenant signing/profile boundaries with synthetic data; no Apple or Firebase account is used."""
import copy
from datetime import datetime, timedelta, timezone
import hashlib
import io
import json
from pathlib import Path
import plistlib
import stat
import tempfile
import unittest
from unittest.mock import patch
import zipfile

import mobile_ios_release as release


class IosReleaseTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="ios-release-test-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.cert = b"synthetic-public-certificate-data"
        self.settings = {"AllowSigning": True, "AllowFirebaseWrites": False,
                         "DevelopmentTeam": "ABCDE12345", "SigningCertificateSha1": hashlib.sha1(self.cert).hexdigest(),
                         "RequiredDeviceUdids": ["A" * 40]}
        for key in ["ApplicationProfile", "ExtensionProfile"]:
            path = self.root / (key + ".mobileprovision"); path.write_bytes(b"synthetic-profile-cms"); path.chmod(0o600)
            self.settings[key] = str(path)
        self.tenant = {"developmentTeam": "ABCDE12345", "iosBundleId": "dev.commerce.fixture", "extensionBundleId": "dev.commerce.fixture.NotificationServiceExtension"}
        self.value = {"UUID": "11111111-1111-1111-1111-111111111111", "Platform": ["iOS"],
                      "TeamIdentifier": ["ABCDE12345"], "ApplicationIdentifierPrefix": ["ABCDE12345"],
                      "ExpirationDate": datetime.now(timezone.utc) + timedelta(days=90),
                      "ProvisionedDevices": ["A" * 40], "DeveloperCertificates": [self.cert],
                      "Entitlements": {"application-identifier": "ABCDE12345.dev.commerce.fixture", "com.apple.developer.team-identifier": "ABCDE12345",
                                       "get-task-allow": False, "aps-environment": "production", "keychain-access-groups": ["ABCDE12345.*"]}}

    def profile(self, value=None):
        return release.profile_guard(self.value if value is None else value, self.tenant["iosBundleId"], self.settings, True)

    def config(self, settings=None):
        path = self.root / "signing.json"
        path.write_text(json.dumps(self.settings if settings is None else settings)); path.chmod(0o600)
        return path

    def test_policy_is_explicit_private_and_bound_to_the_selected_team(self):
        self.assertEqual(release.policy(self.config(), self.tenant)["DevelopmentTeam"], "ABCDE12345")
        for change in [{"AllowSigning": False}, {"AllowSigning": "true"}, {"DevelopmentTeam": "ZZZZZ99999"},
                       {"SigningCertificateSha1": "Apple Distribution"}, {"RequiredDeviceUdids": []},
                       {"AllowFirebaseWrites": "false"}, {"ApplicationProfile": "relative.mobileprovision"}, {"UnknownOption": True}]:
            with self.subTest(keys=tuple(change)):
                value = dict(self.settings); value.update(change)
                with self.assertRaises(ValueError): release.policy(self.config(value), self.tenant)
        path = self.config(); path.chmod(0o644)
        with self.assertRaises(ValueError): release.policy(path, self.tenant)

    def test_signing_cannot_start_on_linux(self):
        with patch.object(release.platform, "system", return_value="Linux"), patch.object(release, "apple") as apple:
            with self.assertRaises(ValueError): release.signing_plan(self.settings, self.tenant)
        apple.assert_not_called()

    def test_distribution_profile_preserves_legacy_app_prefix_without_confusing_the_team(self):
        self.assertEqual(self.profile()["deviceCount"], 1)
        value = copy.deepcopy(self.value); value["ApplicationIdentifierPrefix"] = ["ZZZZZ99999"]
        value["Entitlements"]["application-identifier"] = "ZZZZZ99999.dev.commerce.fixture"
        self.assertEqual(self.profile(value)["entitlements"]["application-identifier"], "ZZZZZ99999.dev.commerce.fixture")

    def test_wrong_team_bundle_signer_expired_debug_enterprise_and_missing_device_profiles_fail(self):
        mutations = [
            {"TeamIdentifier": ["ZZZZZ99999"]}, {"Platform": ["macOS"]}, {"ProvisionsAllDevices": True},
            {"ExpirationDate": datetime.now(timezone.utc) - timedelta(seconds=1)},
            {"ProvisionedDevices": ["B" * 40]}, {"DeveloperCertificates": [b"foreign-public-certificate"]},
            {"UUID": "00000000-0000-0000-0000-000000000000"},
        ]
        for change in mutations:
            with self.subTest(keys=tuple(change)):
                value = copy.deepcopy(self.value); value.update(change)
                with self.assertRaises(ValueError): self.profile(value)
        for key, value in [("application-identifier", "ABCDE12345.dev.foreign.app"), ("get-task-allow", True), ("aps-environment", "development"), ("com.apple.developer.team-identifier", "ZZZZZ99999")]:
            with self.subTest(entitlement=key):
                data = copy.deepcopy(self.value); data["Entitlements"][key] = value
                with self.assertRaises(ValueError): self.profile(data)

    def test_signed_entitlements_must_stay_inside_profile_permissions(self):
        allowed = self.value["Entitlements"]
        actual = dict(allowed, **{"keychain-access-groups": ["ABCDE12345.dev.commerce.fixture"]})
        self.assertTrue(release.authorize(actual, allowed))
        for change in [{"keychain-access-groups": ["FOREIGN.dev.app"]}, {"get-task-allow": True},
                       {"aps-environment": "development"}, {"unapproved-entitlement": True}]:
            value = dict(actual); value.update(change)
            self.assertFalse(release.authorize(value, allowed))

    def ipa(self, members):
        path = self.root / "input.ipa"
        with zipfile.ZipFile(path, "w") as archive:
            for name, contents in members: archive.writestr(name, contents)
        return path

    def test_unsafe_ipa_paths_are_rejected_before_any_file_is_extracted(self):
        for name in ["../escape", "/absolute", "Payload/Runner.app/../../escape", "Payload\\escape", "private-key.p8", "Payload/Foreign.app/Info.plist"]:
            with self.subTest(name=name):
                path = self.ipa([("Payload/Runner.app/keep", b"safe"), (name, b"bad")])
                output = self.root / "unpacked"; output.mkdir(exist_ok=True)
                with self.assertRaises(ValueError): release.unpack_ipa(path, output)
                self.assertEqual(list(output.iterdir()), [])

    def test_ipa_symlinks_and_case_collisions_are_rejected(self):
        link = zipfile.ZipInfo("Payload/Runner.app/link"); link.create_system = 3
        link.external_attr = (stat.S_IFLNK | 0o777) << 16
        path = self.ipa([("Payload/Runner.app/keep", b"safe"), (link, b"/outside")])
        output = self.root / "unpacked"; output.mkdir()
        with self.assertRaises(ValueError): release.unpack_ipa(path, output)
        self.assertEqual(list(output.iterdir()), [])
        path = self.ipa([("Payload/Runner.app/Info.plist", b"first"), ("Payload/Runner.app/info.plist", b"second")])
        with self.assertRaises(ValueError): release.unpack_ipa(path, output)

    def test_safe_ipa_stays_in_its_private_destination(self):
        path = self.ipa([("Payload/Runner.app/Info.plist", b"plist"), ("SwiftSupport/iphoneos/library.dylib", b"library")])
        output = self.root / "unpacked"; output.mkdir()
        self.assertEqual(release.unpack_ipa(path, output), output / "Payload/Runner.app")
        self.assertEqual((output / "Payload/Runner.app/Info.plist").read_bytes(), b"plist")
        self.assertEqual((output / "Payload/Runner.app/Info.plist").stat().st_mode & 0o777, 0o600)

    def test_signed_application_must_keep_push_permission_and_the_selected_leaf_certificate(self):
        app = self.root / "Signed.app"; app.mkdir()
        raw = b"synthetic-embedded-profile"; (app / "embedded.mobileprovision").write_bytes(raw)
        profile = dict(self.profile(), sha256=hashlib.sha256(raw).hexdigest(), bundle=self.tenant["iosBundleId"])
        selected = hashlib.sha256(self.cert).hexdigest()
        actual = dict(profile["entitlements"])
        def command(args):
            if "--entitlements" in args: return plistlib.dumps(actual)
            for item in args:
                if item.startswith("--extract-certificates="):
                    Path(item.split("=", 1)[1] + "0").write_bytes(self.cert)
            return b""
        with patch.object(release, "apple", side_effect=command):
            release.check_signature(app, profile, self.settings, selected)
            actual.pop("aps-environment")
            with self.assertRaisesRegex(ValueError, "production push"):
                release.check_signature(app, profile, self.settings, selected)
            actual["aps-environment"] = "production"
            with self.assertRaisesRegex(ValueError, "different signing certificate"):
                release.check_signature(app, profile, self.settings, "0" * 64)

    def test_foreign_symbol_uuid_cannot_be_uploaded_for_the_release(self):
        app = self.root / "Runner.app"; app.mkdir()
        archive = self.root / "Runner.xcarchive"
        for label, dsym in [("Runner", "Runner.app.dSYM"), ("App", "App.framework.dSYM")]:
            dwarf = archive / "dSYMs" / dsym / "Contents/Resources/DWARF" / label
            dwarf.parent.mkdir(parents=True); dwarf.write_bytes(b"synthetic-symbols")
        same = "11111111-1111-1111-1111-111111111111"
        different = "22222222-2222-2222-2222-222222222222"
        with patch.object(release, "uuids", return_value=same):
            symbols, hashes = release.verify_symbols(app, archive)
            self.assertEqual(symbols, {"Runner": same, "App": same})
            self.assertEqual(hashes, {name: hashlib.sha256(b"synthetic-symbols").hexdigest() for name in ["Runner", "App"]})
        with patch.object(release, "uuids", side_effect=[same, different]):
            with self.assertRaises(ValueError): release.verify_symbols(app, archive)

    def test_archive_and_export_bind_each_target_profile_without_portal_mutation_flags(self):
        workspace = self.root / "workspace"; workspace.mkdir()
        app = workspace / "Platforms/store_user_app"; app.mkdir(parents=True)
        plan = {"application": {"bundle": self.tenant["iosBundleId"], "uuid": "11111111-1111-1111-1111-111111111111"},
                "extension": {"bundle": self.tenant["extensionBundleId"], "uuid": "22222222-2222-2222-2222-222222222222"}}
        commands = []
        def run(command, *unused):
            commands.append(command)
            if "-exportArchive" in command:
                output = workspace / "ios-release/export"; output.mkdir()
                (output / "Runner.ipa").write_bytes(b"synthetic-export-for-orchestration-test")
        with patch.object(release, "policy", return_value=self.settings), patch.object(release, "signing_plan", return_value=plan), \
             patch.object(release.common, "run_private", side_effect=run), patch.object(release, "verify_ipa", return_value={"signedIpaBuilt": True}) as verify:
            native = unittest.mock.Mock()
            binary, result, settings = release.build(workspace, self.tenant, self.root / "config", "ruby", "flutter", io.StringIO(), native, None)
        native.assert_called_once()
        verify.assert_called_once()
        self.assertTrue(result["signedIpaBuilt"])
        self.assertTrue(binary.is_file())
        self.assertFalse(any("allowProvisioningUpdates" in item or "authenticationKey" in item for command in commands for item in command))
        options = plistlib.loads((workspace / "ios-release/ExportOptions.plist").read_bytes())
        self.assertEqual(options["method"], "release-testing")
        self.assertEqual(options["signingStyle"], "manual")
        self.assertFalse(options["manageAppVersionAndBuildNumber"])
        self.assertEqual(options["provisioningProfiles"], {plan[key]["bundle"]: plan[key]["uuid"] for key in ["application", "extension"]})

    def test_upload_rechecks_the_verified_sdk_and_symbol_bytes_before_any_network_write(self):
        binary = self.root / "Runner.ipa"; binary.write_bytes(b"verified-synthetic")
        app = self.root / "Platforms/store_user_app"
        sdk = app / "ios/Runner/GoogleService-Info.plist"; sdk.parent.mkdir(parents=True)
        contents = {"PROJECT_ID": "fixture", "API_KEY": "synthetic-public-key"}
        sdk.write_bytes(plistlib.dumps(contents))
        tool = app / "ios/Pods/FirebaseCrashlytics/upload-symbols"; tool.parent.mkdir(parents=True); tool.write_text("synthetic-not-executed")
        result = {"symbolsVerified": True, "xcodeExported": True, "ipaSha256": release.common.file_hash(binary),
                  "iosSdkSha256": hashlib.sha256(plistlib.dumps(contents, sort_keys=True)).hexdigest(), "symbolDwarfSha256": {}}
        paths = []
        for label, _, dsym in release.SYMBOL_BUNDLES:
            path = self.root / "ios-release/Runner.xcarchive/dSYMs" / dsym / "Contents/Resources/DWARF" / label
            path.parent.mkdir(parents=True); path.write_bytes(b"verified-synthetic-symbols")
            result["symbolDwarfSha256"][label] = release.common.file_hash(path); paths.append(path)
        settings = dict(self.settings, AllowFirebaseWrites=True)
        with patch.object(release.common, "run_private") as uploader:
            release.upload_symbols(self.root, binary, result, settings, None)
            uploader.assert_called_once()
            self.assertTrue(result["symbolsUploaded"])
            uploader.reset_mock()
            paths[0].write_bytes(b"changed-symbols")
            with self.assertRaisesRegex(ValueError, "symbols changed"):
                release.upload_symbols(self.root, binary, result, settings, None)
            paths[0].write_bytes(b"verified-synthetic-symbols")
            sdk.write_bytes(plistlib.dumps(dict(contents, API_KEY="changed-public-key")))
            with self.assertRaisesRegex(ValueError, "SDK input changed"):
                release.upload_symbols(self.root, binary, result, settings, None)
            uploader.assert_not_called()

    def test_distribution_target_must_match_the_authoritative_tenant_export_before_writes(self):
        sdk = {"PROJECT_ID": "fixture-project", "API_KEY": "synthetic-public-key"}
        client = {"tenantId": "1" * 32, "projectId": "fixture-project", "projectNumber": "123456789", "iosAppId": "1:123456789:ios:bbbbbbbb", "iosBundleId": "dev.commerce.fixture"}
        tenant = dict(client, iosSdkSha256=hashlib.sha256(plistlib.dumps(sdk, sort_keys=True)).hexdigest())
        config = self.root / "cloud.json"; config.write_text("{}"); config.chmod(0o600)
        exported_client, exported_sdk = dict(client), dict(sdk)
        def export(command, *unused):
            self.assertIn("export-mobile", command)
            self.assertNotIn("distribute", command)
            self.assertEqual(command[command.index("--tenant") + 1], tenant["tenantId"])
            output = Path(command[command.index("--output") + 1])
            release.common.private_json(output / "firebase-client.json", exported_client)
            path = output / "GoogleService-Info.plist"; path.write_bytes(plistlib.dumps(exported_sdk)); path.chmod(0o600)
        with patch.object(release.common, "run_private", side_effect=export):
            good = self.root / "good"; good.mkdir()
            release.verify_distribution_target(good, tenant, config, None)
            for name in client:
                work = self.root / name; work.mkdir()
                exported_client[name] = "foreign"
                with self.subTest(field=name), self.assertRaisesRegex(ValueError, "stored Firebase identity"):
                    release.verify_distribution_target(work, tenant, config, None)
                exported_client[name] = client[name]
            work = self.root / "wrong-sdk"; work.mkdir()
            exported_sdk["API_KEY"] = "changed-public-key"
            with self.assertRaisesRegex(ValueError, "stored Firebase configuration"):
                release.verify_distribution_target(work, tenant, config, None)

    def test_symbol_upload_cannot_run_without_permission_or_after_artifact_mutation(self):
        binary = self.root / "Runner.ipa"; binary.write_bytes(b"verified-synthetic")
        result = {"symbolsVerified": True, "xcodeExported": True, "ipaSha256": release.common.file_hash(binary)}
        with patch.object(release.common, "run_private") as uploader:
            with self.assertRaises(ValueError): release.upload_symbols(self.root, binary, result, self.settings, None)
            settings = dict(self.settings, AllowFirebaseWrites=True); binary.write_bytes(b"changed")
            with self.assertRaises(ValueError): release.upload_symbols(self.root, binary, result, settings, None)
        uploader.assert_not_called()


if __name__ == "__main__":
    unittest.main()
