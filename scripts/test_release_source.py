# SPDX-License-Identifier: GPL-3.0-only
"""Provenance evidence must not silently survive changed or missing source files."""
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import asset_inventory


class AssetEvidenceTests(unittest.TestCase):
    def test_changed_asset_cannot_reuse_previous_grant(self):
        with self.assertRaisesRegex(SystemExit, 'Asset changed'):
            asset_inventory.category('demo.png', 'new', {
                'demo.png': {'sha256': 'old', 'license': 'MIT', 'evidence': 'LICENSE'},
            })

    def test_missing_notice_is_not_accepted_as_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            with patch.object(asset_inventory, 'ROOT', Path(directory)):
                with self.assertRaisesRegex(SystemExit, 'Missing asset license'):
                    asset_inventory.category('demo.png', 'same', {
                        'demo.png': {'sha256': 'same', 'license': 'MIT', 'evidence': 'missing.txt'},
                    })

    def test_unchanged_asset_with_retained_notice_is_recognized(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'LICENSE').write_text('Retained grant')
            with patch.object(asset_inventory, 'ROOT', root):
                status, evidence = asset_inventory.category('demo.png', 'same', {
                    'demo.png': {'sha256': 'same', 'license': 'MIT', 'evidence': 'LICENSE'},
                })
                self.assertEqual((status, evidence), ('evidenced:MIT', 'LICENSE'))

    def test_retention_decision_does_not_assert_license_clearance(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'retention.md').write_text('Maintainer requested preservation; no license asserted')
            with patch.object(asset_inventory, 'ROOT', root):
                status, evidence = asset_inventory.category('existing.png', 'same', {
                    'existing.png': {
                        'sha256': 'same', 'license': 'NOASSERTION',
                        'evidence': 'retention.md', 'method': 'retained-existing-asset-user-direction',
                    },
                })
                self.assertEqual(status, 'retained:license-unconfirmed')
                self.assertFalse(status.startswith('evidenced:'))
                self.assertEqual(evidence, 'retention.md')

    def test_unreviewed_asset_stays_visible(self):
        self.assertTrue(asset_inventory.category('unknown.png', 'new', {})[0].startswith('review-'))


class CandidateExportTests(unittest.TestCase):
    def test_only_staged_source_is_exported_without_private_history(self):
        import contextlib
        import io
        import json
        import shutil
        import subprocess
        import sys
        import prepare_public_release

        scripts = Path(__file__).resolve().parent
        with tempfile.TemporaryDirectory(prefix='release-fixture-') as directory:
            base = Path(directory)
            root = base / 'repository'
            root.mkdir()
            def git(*args):
                return subprocess.run(['git', *args], cwd=root, check=True, capture_output=True)
            git('init', '--quiet')
            (root / 'scripts').mkdir()
            (root / 'docs/licenses').mkdir(parents=True)
            for name in ['asset_inventory.py', 'check_public_source.py']:
                shutil.copyfile(scripts / name, root / 'scripts' / name)
            (root / 'docs/licenses/provenance.json').write_text(json.dumps({'files': {}}))
            (root / '.gitignore').write_text('.local/\n')
            (root / '.gitleaks.toml').write_text('[extend]\nuseDefault = true\n')
            (root / 'LICENSE').write_text('Fixture grant')
            history_only = root / 'private-history-only.txt'
            history_only.write_text('Old file must stay in the private ancestry')
            git('add', '--all')
            git('-c', 'user.name=Fixture', '-c', 'user.email=fixture@example.test',
                '-c', 'commit.gpgsign=false', 'commit', '--quiet', '-m', 'Private fixture')
            original_head = git('rev-parse', 'HEAD').stdout
            history_only.unlink()
            (root / 'current.txt').write_text('reviewed staged value')
            (root / '.local').mkdir()
            (root / '.local/credentials.json').write_text('{"private":"fixture"}')
            git('add', '--all')
            subprocess.run([sys.executable, 'scripts/asset_inventory.py', '--index'],
                           cwd=root, check=True, capture_output=True)
            git('add', '--all')
            (root / 'current.txt').write_text('unrelated unstaged edit')
            (root / 'untracked.txt').write_text('not reviewed')
            scanner = base / 'test-scanner'
            scanner.write_text('#!/bin/sh\nexit 0\n')
            scanner.chmod(0o700)
            candidate = root / '.local/candidate'
            with patch.object(prepare_public_release, 'ROOT', root), patch.object(sys, 'argv', [
                'prepare_public_release.py', '--output', str(candidate), '--gitleaks', str(scanner),
            ]), contextlib.redirect_stdout(io.StringIO()):
                prepare_public_release.main()
            self.assertEqual((candidate / 'current.txt').read_text(), 'reviewed staged value')
            self.assertFalse((candidate / 'private-history-only.txt').exists())
            self.assertFalse((candidate / 'untracked.txt').exists())
            self.assertFalse((candidate / '.local/credentials.json').exists())
            self.assertNotEqual(subprocess.run(['git', 'rev-parse', '--verify', 'HEAD'],
                                cwd=candidate, capture_output=True).returncode, 0)
            self.assertEqual(git('rev-parse', 'HEAD').stdout, original_head)
            self.assertEqual((root / 'current.txt').read_text(), 'unrelated unstaged edit')

    def test_existing_output_is_never_overwritten(self):
        import contextlib
        import io
        import sys
        import prepare_public_release
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            candidate = root / '.local/existing'
            candidate.mkdir(parents=True)
            marker = candidate / 'keep.txt'
            marker.write_text('keep')
            with patch.object(prepare_public_release, 'ROOT', root), patch.object(sys, 'argv', [
                'prepare_public_release.py', '--output', str(candidate), '--gitleaks', 'unused',
            ]), contextlib.redirect_stderr(io.StringIO()), self.assertRaises(SystemExit):
                prepare_public_release.main()
            self.assertEqual(marker.read_text(), 'keep')


if __name__ == '__main__':
    unittest.main()
