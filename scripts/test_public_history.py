# SPDX-License-Identifier: GPL-3.0-only
import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path
import prepare_public_history as history


@unittest.skipUnless(shutil.which(os.environ.get('GIT_FILTER_REPO', 'git-filter-repo')), 'Install pinned git-filter-repo for actual history-rewrite tests')
class HistoryReleaseTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='public-history-test-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / 'repo'
        self.root.mkdir()
        self.git('init', '-q', '-b', 'codex/fixture')
        self.git('config', 'user.name', 'Fixture Author')
        self.git('config', 'user.email', 'fixture@example.test')
        self.git('config', 'commit.gpgsign', 'false')
        self.write('.gitignore', '.local/\n')
        self.write('docs/licenses/history-removals.json', '{}')
        self.write('scripts/check_public_source.py', 'pass\n')
        self.write('scripts/asset_inventory.py', 'pass\n')
        self.write('.gitleaks.toml', '[extend]\nuseDefault=true\n')
        self.write('restricted.ttf', 'synthetic forbidden fixture, not a real font')
        self.blob = self.git('hash-object', 'restricted.ttf').decode().strip()
        self.commit('initial work')
        self.git('checkout', '-q', '-b', 'codex/feature')
        self.git('mv', 'restricted.ttf', 'renamed.ttf')
        self.commit('rename restricted font')
        self.git('rm', '-q', 'renamed.ttf')
        self.commit('remove restricted font')
        self.git('checkout', '-q', 'codex/fixture')
        self.write('keep.txt', 'maintained application')
        self.commit('independent development')
        self.git('merge', '--no-ff', '-q', 'codex/feature', '-m', 'preserve merge topology')
        self.write('docs/licenses/history-removals.json', json.dumps({'paths': ['restricted.ttf'], 'blobIds': [self.blob]}))
        self.commit('review exact cleanup policy')
        self.head = self.git('rev-parse', 'HEAD')
        self.scanner = Path(self.temp.name) / 'test-scanner'
        self.scanner.write_text('#!/bin/sh\nexit 0\n')
        self.scanner.chmod(0o700)
        self.tool = shutil.which(os.environ.get('GIT_FILTER_REPO', 'git-filter-repo'))

    def write(self, name, text):
        p = self.root / name
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(text)

    def git(self, *args):
        return history.git(self.root, *args)

    def commit(self, message):
        self.git('add', '--all')
        self.git('commit', '-q', '-m', message)

    def test_real_filter_preserves_merge_empty_commits_and_unrelated_work(self):
        self.write('keep.txt', 'unstaged user edit')
        self.write('.local/credentials.json', '{"fixture":"private, never exported"}')
        output = self.root / '.local/candidate'
        result = history.prepare(self.root, output, str(self.scanner), self.tool)
        self.assertEqual(result['commitsPreserved'], 6)
        self.assertEqual((output / 'keep.txt').read_text(), 'maintained application')
        self.assertEqual((self.root / 'keep.txt').read_text(), 'unstaged user edit')
        self.assertFalse((output / '.local/credentials.json').exists())
        self.assertEqual(self.git('rev-parse', 'HEAD'), self.head)
        self.assertEqual(history.git(output, 'rev-list', '--count', '--merges', 'HEAD').strip(), b'1')
        self.assertNotIn(self.blob.encode(), history.git(output, 'rev-list', '--objects', '--all'))
        history.history_guard(output)

    def test_existing_output_is_not_overwritten(self):
        output = self.root / '.local/candidate'
        output.mkdir(parents=True)
        marker = output / 'keep.txt'; marker.write_text('retain')
        with self.assertRaisesRegex(ValueError, 'new output'):
            history.prepare(self.root, output, str(self.scanner), self.tool)
        self.assertEqual(marker.read_text(), 'retain')

    def test_unreviewed_staged_edits_are_rejected(self):
        self.write('keep.txt', 'pending')
        self.git('add', 'keep.txt')
        with self.assertRaisesRegex(ValueError, 'Commit the intended'):
            history.prepare(self.root, self.root / '.local/candidate', str(self.scanner), self.tool)

    def test_guard_rejects_restricted_content_under_a_renamed_path(self):
        with self.assertRaisesRegex(ValueError, 'Restricted'):
            history.history_guard(self.root)


if __name__ == '__main__':
    unittest.main()
