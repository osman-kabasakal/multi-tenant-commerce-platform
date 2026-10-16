#!/usr/bin/env python3
"""Cloud-free contracts for tenant Android preparation and build-process boundaries."""
import copy
import io
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch
import xml.etree.ElementTree as ET

import mobile_android as mobile


def fixtures():
    tenant = '123456781234123412341234567890ab'
    client = dict(tenantId=tenant, projectId='tenant-project', projectNumber='12345', androidAppId='1:12345:android:abc123', iosAppId='1:12345:ios:def456', androidPackageName='com.example.tenantapp', iosBundleId='com.example.tenantapp')
    manifest = dict(tenantId=tenant, slug='test-shop', displayName='Şirket & Owner\'s "Shop"', baseUrl='https://test-shop.shops.example.test', localDemo=False, androidApplicationId=client['androidPackageName'], iosBundleId=client['iosBundleId'], firebase=dict(enabled=True, **{k: client[k] for k in ('projectId', 'projectNumber', 'androidAppId', 'iosAppId')}))
    android = dict(project_info=dict(project_id=client['projectId'], project_number=client['projectNumber']), client=[dict(client_info=dict(mobilesdk_app_id=client['androidAppId'], android_client_info=dict(package_name=client['androidPackageName'])), api_key=[dict(current_key='synthetic-public-client-key')])], configuration_version='1')
    return manifest, client, android


class IdentityTests(unittest.TestCase):
    def test_accepts_one_owned_firebase_android_app(self):
        manifest, client, android = fixtures()
        self.assertEqual(mobile.validate(manifest, client, android)['androidApplicationId'], client['androidPackageName'])

    def test_foreign_or_disabled_manifests_are_refused(self):
        for where, key, value in [('manifest', 'tenantId', 'f' * 32), ('manifest', 'localDemo', True), ('manifest', 'androidApplicationId', 'com.example.foreign'), ('client', 'projectId', 'foreign-project'), ('client', 'androidAppId', '1:12345:android:ffff'), ('client', 'projectNumber', '99999')]:
            with self.subTest(where=where, key=key):
                manifest, client, android = fixtures()
                (manifest if where == 'manifest' else client)[key] = value
                with self.assertRaises(ValueError): mobile.validate(manifest, client, android)
        manifest, client, android = fixtures(); manifest['firebase']['enabled'] = False
        with self.assertRaises(ValueError): mobile.validate(manifest, client, android)

    def test_sdk_project_package_app_and_duplicate_clients_are_refused(self):
        for change in ('project', 'number', 'package', 'app', 'duplicate'):
            with self.subTest(change=change):
                manifest, client, android = fixtures()
                if change == 'project': android['project_info']['project_id'] = 'foreign-project'
                elif change == 'number': android['project_info']['project_number'] = '99999'
                elif change == 'package': android['client'][0]['client_info']['android_client_info']['package_name'] = 'com.example.foreign'
                elif change == 'app': android['client'][0]['client_info']['mobilesdk_app_id'] = '1:12345:android:ffff'
                else: android['client'].append(copy.deepcopy(android['client'][0]))
                with self.assertRaises(ValueError): mobile.validate(manifest, client, android)

    def test_only_owned_https_origins_are_accepted(self):
        for url in ['http://test-shop.shops.example.test', 'https://other-shop.shops.example.test', 'https://user:password@test-shop.shops.example.test', 'https://test-shop.shops.example.test/path', 'https://test-shop.shops.example.test/?token=value', 'https://test-shop.shops.example.test/#fragment', 'https://test-shop.shops.example.test:0', 'https://test-shop.shops.example.test:70000']:
            with self.subTest(url=url):
                manifest, client, android = fixtures(); manifest['baseUrl'] = url
                with self.assertRaises(ValueError): mobile.validate(manifest, client, android)

    def test_canonical_identity_and_native_package_are_required(self):
        for key, value in [('tenantId', '0' * 32), ('tenantId', '12345678-1234-1234-1234-1234567890ab'), ('slug', '../../foreign'), ('displayName', 'bad\nname')]:
            manifest, client, android = fixtures(); manifest[key] = value
            if key == 'tenantId': client[key] = value
            with self.subTest(key=key), self.assertRaises(ValueError): mobile.validate(manifest, client, android)


class SdkToolTests(unittest.TestCase):
    def test_verification_uses_the_pinned_build_tools_even_when_newer_versions_exist(self):
        with tempfile.TemporaryDirectory() as temporary:
            sdk = Path(temporary)
            for version in [mobile.BUILD_TOOLS_VERSION, '37.0.0']:
                for name in ['aapt2', 'apksigner']:
                    suffix = ('.bat' if name == 'apksigner' else '.exe') if os.name == 'nt' else ''
                    path = sdk / 'build-tools' / version / (name + suffix)
                    path.parent.mkdir(parents=True, exist_ok=True); path.write_text('Synthetic tool fixture')
            for name in ['aapt2', 'apksigner']:
                self.assertEqual(mobile.sdk_tool(sdk, name).parent.name, mobile.BUILD_TOOLS_VERSION)

    def test_missing_pinned_tools_do_not_fall_back_to_an_unverified_version(self):
        with tempfile.TemporaryDirectory() as temporary:
            sdk = Path(temporary)
            path = sdk / 'build-tools/37.0.0/aapt2'; path.parent.mkdir(parents=True); path.write_text('Synthetic tool fixture')
            with self.assertRaises(ValueError): mobile.sdk_tool(sdk, 'aapt2')
            with self.assertRaises(ValueError): mobile.sdk_tool(sdk, '../foreign')


class WorkspaceTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='tenant-android-test-', dir=Path(tempfile.gettempdir()).resolve())
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.root = self.directory / 'source'; self.root.mkdir()
        self.config = self.directory / 'config'; self.config.mkdir()
        self.manifest, client, android = fixtures()
        for name, value in [('manifest.json', self.manifest), ('firebase-client.json', client), ('google-services.json', android)]:
            (self.config / name).write_text(json.dumps(value))
        self.sources = []
        for name in ['Platforms/store_user_app/pubspec.lock', 'Platforms/store_user_app/lib/core/config/tenant_firebase_identity.dart', 'Platforms/modules/fixture/pubspec.yaml']:
            path = self.root / name; path.parent.mkdir(parents=True, exist_ok=True); path.write_text('source fixture')
            self.sources.append((path, name))

    def prepare(self, path=None, version=7):
        with patch.object(mobile, 'source_files', return_value=self.sources):
            return mobile.prepare(self.config / 'manifest.json', self.config, path or self.directory / 'workspace', version, self.root)

    def test_isolated_outputs_bind_native_and_dart_identity_and_escape_labels(self):
        self.manifest['firebase']['androidConfigFile'] = '/private/foreign-credential.json'
        self.manifest['backendSecret'] = 'must-not-be-copied'
        (self.config / 'manifest.json').write_text(json.dumps(self.manifest))
        workspace, tenant = self.prepare()
        self.assertEqual(tenant['tenantId'], self.manifest['tenantId'])
        defines = json.loads((workspace / 'tenant.defines.json').read_text())
        self.assertEqual(defines['LOCAL_DEMO'], 'false')
        self.assertEqual(defines['STORE_URL'], self.manifest['baseUrl'])
        self.assertEqual(defines['FIREBASE_ANDROID_APP_ID'], '1:12345:android:abc123')
        self.assertNotIn('backendSecret', json.dumps(defines))
        self.assertNotIn('must-not-be-copied', (workspace / 'tenant-build.json').read_text())
        self.assertTrue((workspace / 'Platforms/modules/fixture/pubspec.yaml').is_file())
        label = ET.parse(workspace / 'Platforms/store_user_app/android/app/src/tenant/res/values/strings.xml').find('string').text
        self.assertEqual(label, '"Şirket & Owner\'s \\"Shop\\""')
        self.assertFalse((self.root / 'tenant-build.json').exists())
        if os.name != 'nt': self.assertEqual((workspace / 'tenant.defines.json').stat().st_mode & 0o777, 0o600)

    def test_source_hash_is_stable_and_changes_with_tracked_source_contents(self):
        with patch.object(mobile, 'source_files', return_value=self.sources):
            original = mobile.source_hash(self.root)
            self.assertEqual(original, mobile.source_hash(self.root))
            self.sources[0][0].write_text('changed locked dependencies')
            self.assertNotEqual(original, mobile.source_hash(self.root))

    def test_prepared_source_fingerprint_matches_the_copied_checkout(self):
        workspace, tenant = self.prepare()
        copied = [(workspace / name, name) for _, name in self.sources]
        self.assertEqual(tenant['sourceHash'], mobile.hash_sources(copied))
        self.assertEqual(json.loads((workspace / 'tenant-build.json').read_text())['sourceHash'], tenant['sourceHash'])

    def test_source_inspection_cannot_also_build_or_distribute(self):
        result = subprocess.run([sys.executable, str(Path(mobile.__file__)), '--source-hash', '--build'], capture_output=True, text=True)
        self.assertEqual(result.returncode, 2)
        self.assertIn('cannot prepare, build or distribute', result.stderr)

    def test_packaged_mobile_sources_need_no_git_metadata_and_preserve_the_fingerprint(self):
        output = self.directory / 'source-package'
        with patch.object(mobile, 'source_files', return_value=self.sources):
            expected = mobile.source_hash(self.root)
            mobile.package_source(output, self.root)
        self.assertFalse((output / '.git').exists())
        with patch.object(mobile.subprocess, 'check_output', side_effect=AssertionError('Git must not be invoked for a source package')):
            self.assertEqual(mobile.source_hash(output), expected)
        manifest = json.loads((output / 'mobile-source.json').read_text())
        self.assertEqual(len(manifest['files']), len(self.sources))

    def test_source_package_detects_modified_and_missing_files(self):
        output = self.directory / 'source-package'
        with patch.object(mobile, 'source_files', return_value=self.sources): mobile.package_source(output, self.root)
        copied = output / self.sources[0][1]; copied.write_text('changed')
        with self.assertRaises(ValueError): list(mobile.source_files(output))
        copied.unlink()
        with self.assertRaises(ValueError): list(mobile.source_files(output))

    def test_source_package_rejects_traversal_credentials_and_generated_sdk_files(self):
        for index, name in enumerate(['../foreign', '/absolute/foreign', 'Platforms/store_user_app/../foreign', 'Platforms/store_user_app/./lib/x.dart', 'Platforms/store_user_app/google-services.json', 'Platforms/store_user_app/key.p12', 'Platforms/store_user_app/.git/config']):
            output = self.directory / ('invalid-source-' + str(index)); output.mkdir()
            (output / 'mobile-source.json').write_text(json.dumps({'version': 1, 'files': [{'path': name, 'sha256': 'a' * 64}]}))
            with self.subTest(name=name), self.assertRaises(ValueError): list(mobile.source_files(output))

    def test_even_force_tracked_credentials_cannot_be_packaged(self):
        subprocess.run(['git', 'init', '-q', str(self.root)], check=True)
        path = self.root / 'Platforms/store_user_app/android/service-account.json'
        path.parent.mkdir(parents=True, exist_ok=True); path.write_text('{}')
        subprocess.run(['git', 'add', '--', 'Platforms'], cwd=self.root, check=True)
        with self.assertRaises(ValueError): list(mobile.source_files(self.root))

    def test_source_package_never_overwrites_an_existing_directory(self):
        output = self.directory / 'existing-package'; output.mkdir(); marker = output / 'keep'; marker.write_text('keep')
        with self.assertRaises(ValueError): mobile.package_source(output, self.root)
        self.assertEqual(marker.read_text(), 'keep')

    def test_never_overwrites_an_existing_workspace(self):
        existing = self.directory / 'existing'; existing.mkdir(); marker = existing / 'important'; marker.write_text('keep')
        with self.assertRaises(ValueError): self.prepare(existing)
        self.assertEqual(marker.read_text(), 'keep')

    def test_refuses_a_public_source_workspace_and_invalid_version(self):
        with self.assertRaises(ValueError): self.prepare(self.root / 'Platforms/generated')
        for version in [0, -1, 2100000001]:
            with self.subTest(version=version), self.assertRaises(ValueError): self.prepare(version=version)

    def test_refuses_symbolic_links_for_configuration_and_workspace(self):
        if os.name == 'nt': self.skipTest('Unix symbolic links')
        link = self.directory / 'link'; link.symlink_to(self.config, target_is_directory=True)
        with self.assertRaises(ValueError): self.prepare(link / 'new')
        source = self.config / 'manifest.json'; source.rename(self.config / 'actual.json'); source.symlink_to(self.config / 'actual.json')
        with self.assertRaises(ValueError): self.prepare()

    def test_copies_only_explicitly_tracked_mobile_sources(self):
        subprocess.run(['git', 'init', '-q', str(self.root)], check=True)
        subprocess.run(['git', 'add', '--', 'Platforms'], cwd=self.root, check=True)
        untracked = self.root / 'Platforms/store_user_app/private.json'; untracked.write_text('untracked private fixture')
        names = [name for _, name in mobile.source_files(self.root)]
        self.assertNotIn('Platforms/store_user_app/private.json', names)
        self.assertEqual(len(names), len(self.sources))

    def test_json_size_type_and_symlink_constraints(self):
        path = self.config / 'invalid.json'; path.write_text('[]')
        with self.assertRaises(ValueError): mobile.read_json(path)
        path.write_text(' ' * (mobile.MAX_CONFIG_BYTES + 1))
        with self.assertRaises(ValueError): mobile.read_json(path)

    def test_build_refuses_shared_signing_configuration_before_running_tools(self):
        workspace, tenant = self.prepare(); signing = self.config / 'signing.properties'; signing.write_text('synthetic-signing-config')
        if os.name == 'nt': self.skipTest('Unix permissions')
        signing.chmod(0o644)
        with patch.object(mobile, 'run_private') as run, self.assertRaises(ValueError):
            mobile.build(workspace, tenant, signing, 'flutter', self.directory, 7, io.StringIO())
        run.assert_not_called()

    def test_no_distribution_without_actual_build(self):
        result = subprocess.run([sys.executable, str(Path(mobile.__file__)), str(self.config / 'manifest.json'), '--firebase-directory', str(self.config), '--distribute-config', str(self.config / 'operator.json')], capture_output=True, text=True)
        self.assertEqual(result.returncode, 2)
        self.assertIn('requires an actual signed --build', result.stderr)

    def test_timed_out_build_process_is_terminated(self):
        with (self.directory / 'process.log').open('w') as log, self.assertRaises(subprocess.TimeoutExpired):
            mobile.run_private([sys.executable, '-c', 'import time;time.sleep(60)'], self.directory, os.environ.copy(), log, .1)


if __name__ == '__main__':
    unittest.main()
