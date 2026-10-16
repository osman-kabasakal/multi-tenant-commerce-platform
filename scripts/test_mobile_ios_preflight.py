"""Exercise iOS preparation gates using synthetic tools; never invoke Apple commands in CI."""
from contextlib import redirect_stdout
import io
import json
from pathlib import Path
from types import SimpleNamespace
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import mobile_ios_preflight as preflight


class IosPreflightTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory(prefix="ios-preflight-test-")
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.flutter = self.root / "flutter-sdk/bin/flutter"
        self.flutter.parent.mkdir(parents=True)
        self.flutter.write_text("synthetic executable; must never execute")
        self.flutter.chmod(0o700)
        self.metadata = self.flutter.parent / "cache/flutter.version.json"
        self.metadata.parent.mkdir()
        self.metadata.write_text(json.dumps({"frameworkVersion": preflight.FLUTTER_VERSION}))
        self.pod = self.root / "pod"
        self.pod.write_text("synthetic executable; must never execute")
        self.pod.chmod(0o700)
        self.settings = preflight.options({"Provisioning": {"Mobile": {"Ios": {
            "DevelopmentTeam": "ABCDE12345", "FlutterPath": str(self.flutter)}}}})
        self.identity = '  1) ' + 'A' * 40 + ' "Apple Distribution: PRIVATE CERTIFICATE SUBJECT (ABCDE12345)"\n     1 valid identities found\n'
        self.responses = {
            ("/usr/bin/xcodebuild", "-version"): "Xcode 26.6\nBuild version 17F113\n",
            ("/usr/bin/xcodebuild", "-checkFirstLaunchStatus"): "",
            ("/usr/bin/xcrun", "--sdk", "iphoneos", "--show-sdk-version"): "26.6\n",
            ("/usr/bin/security", "find-identity", "-v", "-p", "codesigning"): self.identity,
        }

    def report(self, system="Darwin", free=25, pod=True):
        def command(args):
            value = self.responses[tuple(args)]
            if isinstance(value, Exception):
                raise value
            return value
        with patch.object(preflight.platform, "system", return_value=system), \
             patch.object(preflight.shutil, "disk_usage", return_value=SimpleNamespace(free=free * 2**30)), \
             patch.object(preflight.shutil, "which", side_effect=lambda name: str(self.pod) if name == "pod" and pod else None), \
             patch.object(preflight, "command", side_effect=command) as calls:
            result = preflight.inspect(self.settings, self.root)
        return result, calls

    def check(self, report, name):
        return next(x for x in report["checks"] if x["name"] == name)

    def test_ready_only_means_local_build_attempt_and_never_claims_ipa_or_delivery(self):
        report, calls = self.report()
        self.assertTrue(report["readyForBuildAttempt"])
        self.assertFalse(report["signedIpaBuilt"] or report["distributed"])
        self.assertEqual(calls.call_count, 4)
        self.assertNotIn("PRIVATE CERTIFICATE SUBJECT", json.dumps(report))
        self.assertNotIn("A" * 40, json.dumps(report))
        self.assertNotIn(str(self.flutter), json.dumps(report))

    def test_linux_never_starts_apple_tools(self):
        report, calls = self.report(system="Linux")
        calls.assert_not_called()
        self.assertFalse(report["readyForBuildAttempt"])
        self.assertEqual(self.check(report, "macOS")["status"], "failed")

    def test_disk_floor_and_absent_pods_block_a_build_attempt(self):
        report, _ = self.report(free=19.99, pod=False)
        self.assertFalse(report["readyForBuildAttempt"])
        self.assertEqual(self.check(report, "Free disk")["status"], "failed")
        self.assertEqual(self.check(report, "CocoaPods")["status"], "failed")
        report, _ = self.report(free=20)
        self.assertTrue(report["readyForBuildAttempt"])

    def test_missing_team_or_only_development_or_foreign_signer_is_insufficient(self):
        command = ("/usr/bin/security", "find-identity", "-v", "-p", "codesigning")
        for subject in ["Apple Development: PRIVATE (ABCDE12345)", "Apple Distribution: FOREIGN (ZZZZZ99999)"]:
            with self.subTest(subject=subject):
                self.responses[command] = '  1) ' + 'A' * 40 + ' "' + subject + '"\n'
                report, _ = self.report()
                self.assertFalse(report["readyForBuildAttempt"])
                self.assertEqual(self.check(report, "Distribution signing")["matchingTeamIdentityCount"], 0)
        self.settings["DevelopmentTeam"] = ""
        report, _ = self.report()
        self.assertEqual(self.check(report, "Apple Team")["status"], "not-configured")
        self.assertEqual(self.check(report, "Distribution signing")["status"], "not-configured")

    def test_unavailable_apple_checks_do_not_hide_other_requirements_or_echo_output(self):
        self.responses[("/usr/bin/xcodebuild", "-checkFirstLaunchStatus")] = preflight.CheckUnavailable("Local tool could not complete the check.")
        report, _ = self.report(free=1)
        self.assertFalse(report["readyForBuildAttempt"])
        self.assertEqual(self.check(report, "Xcode first launch")["status"], "unavailable")
        self.assertEqual(self.check(report, "Free disk")["status"], "failed")

    def test_sdk_metadata_version_is_pinned_and_flutter_is_not_executed(self):
        with patch.object(preflight.subprocess, "run") as commands:
            self.assertEqual(preflight.flutter_version(str(self.flutter)), preflight.FLUTTER_VERSION)
            commands.assert_not_called()
        self.metadata.write_text('{"frameworkVersion":"0.0.1"}')
        report, _ = self.report()
        self.assertFalse(report["readyForBuildAttempt"])
        self.assertEqual(self.check(report, "Flutter SDK")["status"], "failed")
        self.metadata.unlink()
        with self.assertRaises(preflight.CheckUnavailable):
            preflight.flutter_version(str(self.flutter))
        (self.flutter.parent.parent / "version").write_text(preflight.FLUTTER_VERSION + "\n")
        self.assertEqual(preflight.flutter_version(str(self.flutter)), preflight.FLUTTER_VERSION)

    def test_unknown_sdk_output_cannot_become_a_public_success_message(self):
        self.responses[("/usr/bin/xcodebuild", "-version")] = "PRIVATE TOOL OUTPUT"
        self.responses[("/usr/bin/xcrun", "--sdk", "iphoneos", "--show-sdk-version")] = "PRIVATE TOOL OUTPUT"
        self.metadata.write_text('{"frameworkVersion":"PRIVATE SDK CONTENT"}')
        report, _ = self.report()
        self.assertFalse(report["readyForBuildAttempt"])
        self.assertNotIn("PRIVATE", json.dumps(report))

    def test_invalid_config_stops_before_any_tool_or_private_value_is_printed(self):
        config = self.root / "private.json"
        config.write_text(json.dumps({"Provisioning": {"Mobile": {"Ios": {"DevelopmentTeam": "PRIVATE INVALID TEAM"}}}}))
        config.chmod(0o600)
        output = io.StringIO()
        with redirect_stdout(output), patch.object(preflight, "command") as commands:
            self.assertEqual(preflight.main(["--config", str(config)]), 1)
        commands.assert_not_called()
        self.assertNotIn("PRIVATE INVALID TEAM", output.getvalue())
        self.assertFalse(json.loads(output.getvalue())["readyForBuildAttempt"])

    def test_owner_only_bounded_regular_json_required(self):
        config = self.root / "private.json"
        config.write_text("{}")
        config.chmod(0o644)
        with self.assertRaises(ValueError): preflight.read_json(config, private=True)
        config.chmod(0o600)
        self.assertEqual(preflight.read_json(config, private=True), {})
        link = self.root / "linked.json"; link.symlink_to(config)
        with self.assertRaises(ValueError): preflight.read_json(link, private=True)
        config.write_bytes(b" " * (preflight.MAX_CONFIG_BYTES + 1))
        with self.assertRaises(ValueError): preflight.read_json(config, private=True)

    def test_invalid_options_and_wrong_section_are_rejected(self):
        invalid = [{"MinimumFreeGiB": x} for x in (True, 19, 20.0, float("nan"), "20", 1001)]
        invalid += [{"DevelopmentTeam": "abcde12345"}, {"FlutterPath": "flutter"}, {"FlutterPath": "/bad\x00path"}, {"MinFreeGiB": 20}]
        for value in invalid:
            with self.subTest(keys=tuple(value)):
                with self.assertRaises(ValueError): preflight.options({"Provisioning": {"Mobile": {"Ios": value}}})
        with self.assertRaises(ValueError): preflight.options({"Provisioning": {"Mobile": {"Android": {}}}})

    def test_missing_tool_timeout_and_failure_are_sanitized(self):
        command = ["/usr/bin/xcodebuild", "-version"]
        for failure in [OSError("PRIVATE ERROR"), subprocess.TimeoutExpired(command, 20, output="PRIVATE OUTPUT", stderr="PRIVATE STDERR")]:
            with self.subTest(failure=type(failure).__name__), patch.object(preflight.subprocess, "run", side_effect=failure):
                with self.assertRaises(preflight.CheckUnavailable) as caught: preflight.command(command)
                self.assertNotIn("PRIVATE", str(caught.exception))
        with patch.object(preflight.subprocess, "run", return_value=SimpleNamespace(returncode=1, stdout="PRIVATE", stderr="PRIVATE")):
            with self.assertRaises(preflight.CheckUnavailable) as caught: preflight.command(command)
            self.assertNotIn("PRIVATE", str(caught.exception))

    def test_cli_returns_nonzero_for_missing_prerequisites(self):
        output = io.StringIO()
        with redirect_stdout(output), patch.object(preflight.platform, "system", return_value="Linux"):
            self.assertEqual(preflight.main(["--work-directory", str(self.root)]), 2)
        self.assertFalse(json.loads(output.getvalue())["readyForBuildAttempt"])


if __name__ == "__main__":
    unittest.main()
