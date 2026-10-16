"""Verify iOS tenant identity boundaries without Apple accounts or cloud writes."""
import copy
import hashlib
import json
from pathlib import Path
import plistlib
import tempfile
import unittest
from unittest.mock import patch

import mobile_ios as ios
import smoke_mobile_ios as probe


class IosTenantTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="ios-tenant-test-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.manifest_path = probe.fixture_inputs(self.root / "inputs")
        self.manifest = ios.common.read_json(self.manifest_path)
        self.client = ios.common.read_json(self.manifest_path.parent / "firebase-client.json")
        self.android = ios.common.read_json(self.manifest_path.parent / "google-services.json")
        self.sdk = ios.read_plist(self.manifest_path.parent / "GoogleService-Info.plist")

    def tenant(self):
        return dict(ios.validate(self.manifest, self.client, self.android, self.sdk, "ABCDE12345", 7), buildName="1.0.0", iosSdkSha256=hashlib.sha256(plistlib.dumps(self.sdk, sort_keys=True)).hexdigest())

    def test_foreign_apple_app_project_or_sender_is_rejected_before_copying(self):
        for key in ["BUNDLE_ID", "PROJECT_ID", "GCM_SENDER_ID", "GOOGLE_APP_ID"]:
            with self.subTest(key=key):
                sdk = copy.deepcopy(self.sdk); sdk[key] += "foreign"
                with self.assertRaises(ValueError): ios.validate(self.manifest, self.client, self.android, sdk, "ABCDE12345", 7)
        path = self.manifest_path.parent / "GoogleService-Info.plist"
        bad = dict(self.sdk, BUNDLE_ID="dev.other.app"); path.write_bytes(plistlib.dumps(bad))
        with patch.object(ios.common, "prepare") as copy_sources:
            with self.assertRaises(ValueError): ios.prepare(self.manifest_path, path.parent, self.root / "never-created", "ABCDE12345")
        copy_sources.assert_not_called()
        self.assertFalse((self.root / "never-created").exists())

    def test_numeric_connect_team_invalid_native_bundle_and_build_number_rejected(self):
        for team in ["123456789", "abcde12345", "", "$(TEAM)"]:
            with self.subTest(team=team):
                with self.assertRaises(ValueError): ios.validate(self.manifest, self.client, self.android, self.sdk, team, 7)
        for number in [True, 0, 2100000001, 1.5]:
            with self.subTest(number=number):
                with self.assertRaises(ValueError): ios.validate(self.manifest, self.client, self.android, self.sdk, "ABCDE12345", number)
        self.manifest["iosBundleId"] = self.client["iosBundleId"] = self.sdk["BUNDLE_ID"] = "dev.bad_bundle.app"
        with self.assertRaises(ValueError): self.tenant()

    def test_display_name_cannot_inject_xcode_setting_substitutions(self):
        for name in ["Name $(CONFIGURATION)", "${OTHER_SETTING}"]:
            self.manifest["displayName"] = name
            with self.assertRaises(ValueError): self.tenant()

    def native_app(self):
        app = self.root / "Runner.app"; app.mkdir()
        tenant = self.tenant()
        (app / "Info.plist").write_bytes(plistlib.dumps({"CFBundleIdentifier": tenant["iosBundleId"], "CFBundleVersion": "7", "CFBundleShortVersionString": "1.0.0", "CFBundleSupportedPlatforms": ["iPhoneOS"]}))
        (app / "GoogleService-Info.plist").write_bytes(plistlib.dumps(self.sdk))
        extension = app / "PlugIns/NotificationServiceExtension.appex"; extension.mkdir(parents=True)
        (extension / "Info.plist").write_bytes(plistlib.dumps({"CFBundleIdentifier": tenant["extensionBundleId"], "CFBundleVersion": "7", "CFBundleShortVersionString": "1.0.0", "NSExtension": {"NSExtensionPointIdentifier": "com.apple.usernotifications.service", "NSExtensionPrincipalClass": "NotificationServiceExtension.NotificationService"}}))
        (app / "Runner").write_bytes(b"synthetic-native-executable")
        flutter = app / "Frameworks/App.framework"; flutter.mkdir(parents=True)
        (flutter / "App").write_bytes(b"synthetic-flutter-framework")
        return app, tenant

    def test_compile_verification_never_claims_a_signed_ipa_or_distribution(self):
        app, tenant = self.native_app()
        with patch.object(ios.subprocess, "check_output", side_effect=lambda command, **kw: "arm64\n" if "-archs" in command else "    platform IOS\n") as lipo:
            result = ios.verify_compiled_app(app, tenant)
        self.assertTrue(result["compiledIosApp"])
        self.assertFalse(result["signedIpaBuilt"] or result["distributed"] or result["symbolsUploaded"])
        self.assertEqual(len(result["nativeExecutableSha256"]), 64)
        self.assertEqual(lipo.call_args_list[0].args[0][:2], ["/usr/bin/lipo", "-archs"])

    def test_foreign_bundle_wrong_version_and_missing_extension_fail_native_verification(self):
        app, tenant = self.native_app()
        for key, value in [("CFBundleIdentifier", "dev.foreign.app"), ("CFBundleVersion", "8"), ("CFBundleShortVersionString", "2.0.0")]:
            path = app / "Info.plist"; original = path.read_bytes()
            info = plistlib.loads(original); info[key] = value; path.write_bytes(plistlib.dumps(info))
            with self.assertRaises(ValueError): ios.verify_compiled_app(app, tenant)
            path.write_bytes(original)
        (app / "PlugIns/NotificationServiceExtension.appex/Info.plist").unlink()
        with self.assertRaises(ValueError): ios.verify_compiled_app(app, tenant)

    def test_foreign_firebase_and_wrong_architecture_fail_native_verification(self):
        app, tenant = self.native_app()
        path = app / "GoogleService-Info.plist"; original = path.read_bytes()
        path.write_bytes(plistlib.dumps(dict(self.sdk, GOOGLE_APP_ID="1:123456789:ios:foreign")))
        with self.assertRaises(ValueError): ios.verify_compiled_app(app, tenant)
        path.write_bytes(original)
        with patch.object(ios.subprocess, "check_output", return_value="x86_64 arm64\n"):
            with self.assertRaises(ValueError): ios.verify_compiled_app(app, tenant)

    def test_extension_entry_point_and_version_are_required(self):
        app, tenant = self.native_app()
        path = app / "PlugIns/NotificationServiceExtension.appex/Info.plist"
        original = path.read_bytes()
        for change in [
            {"CFBundleShortVersionString": "2.0.0"},
            {"NSExtension": {"NSExtensionPointIdentifier": "com.apple.usernotifications.service", "NSExtensionPrincipalClass": "WrongModule.NotificationService"}},
            {"NSExtension": {"NSExtensionPointIdentifier": "other.extension", "NSExtensionPrincipalClass": "NotificationServiceExtension.NotificationService"}},
        ]:
            with self.subTest(keys=tuple(change)):
                data = plistlib.loads(original); data.update(change); path.write_bytes(plistlib.dumps(data))
                with self.assertRaises(ValueError): ios.verify_compiled_app(app, tenant)
        path.write_bytes(original)

    def test_arm64_simulator_binary_cannot_pass_as_a_device_release(self):
        app, tenant = self.native_app()
        with patch.object(ios.subprocess, "check_output", side_effect=lambda command, **kw: "arm64\n" if "-archs" in command else "    platform IOSSIMULATOR\n"):
            with self.assertRaises(ValueError): ios.verify_compiled_app(app, tenant)

    def test_non_mac_compile_cannot_start_tools_or_download_dependencies(self):
        with patch.object(ios.platform, "system", return_value="Linux"), patch.object(ios.common, "run_private") as commands:
            with self.assertRaises(ValueError): ios.compile_unsigned(self.root, self.tenant(), "flutter", None)
        commands.assert_not_called()

    def test_cleanup_removes_only_the_exact_owned_probe_cache(self):
        workspace = self.root / ".local" / ("ios-probe-" + "a" * 32) / "workspace"
        base = self.root / "DerivedData"; base.mkdir()
        expected = str(workspace / "Platforms/store_user_app/ios/Runner.xcworkspace")
        for name, value in [("Runner-owned", expected), ("Runner-other-project", "/other/project/Runner.xcworkspace"), ("Runner-other-probe", expected.replace("a" * 32, "b" * 32))]:
            folder = base / name; folder.mkdir()
            (folder / "info.plist").write_bytes(plistlib.dumps({"WorkspacePath": value}))
        outside = self.root / "keep-outside"; outside.mkdir(); (outside / "keep").write_text("keep")
        (base / "Runner-link").symlink_to(outside, target_is_directory=True)
        (base / "Runner-malformed").mkdir(); (base / "Runner-malformed/info.plist").write_bytes(b"bad")
        self.assertEqual(probe.cleanup_derived_data(workspace, base, self.root), 1)
        self.assertFalse((base / "Runner-owned").exists())
        self.assertTrue((base / "Runner-other-project/info.plist").is_file())
        self.assertTrue((base / "Runner-other-probe/info.plist").is_file())
        self.assertTrue((outside / "keep").is_file())
        with self.assertRaises(ValueError): probe.cleanup_derived_data(self.root / "other", base, self.root)

    def test_apple_sdk_plist_cannot_be_linked_or_unbounded(self):
        link = self.root / "linked.plist"; link.symlink_to(self.manifest_path.parent / "GoogleService-Info.plist")
        with self.assertRaises(ValueError): ios.read_plist(link)
        oversized = self.root / "large.plist"; oversized.write_bytes(b" " * (ios.common.MAX_CONFIG_BYTES + 1))
        with self.assertRaises(ValueError): ios.read_plist(oversized)


if __name__ == "__main__":
    unittest.main()
