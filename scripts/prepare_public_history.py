#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-only
"""Prepare a separate, verified public clone while retaining committed development history."""
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = 'docs/licenses/history-removals.json'


def git(root, *args, data=None):
    return subprocess.check_output(['git', *args], cwd=root, input=data)


def load_policy(root):
    policy = json.loads(git(root, 'show', 'HEAD:' + MANIFEST))
    paths = {p.encode() for p in policy['paths']}
    blobs = set(policy['blobIds'])
    if not paths or not blobs or any(len(x) != 40 or any(c not in '0123456789abcdef' for c in x) for x in blobs):
        raise ValueError('Review an explicit nonempty path and Git blob removal policy first.')
    return paths, blobs


def tree(root, commit):
    result = {}
    for item in git(root, 'ls-tree', '-r', '-z', commit).split(b'\0'):
        if item:
            entry, name = item.split(b'\t', 1)
            result[name] = entry.decode().split()
    return result


def commit_data(root, commit):
    headers, message = git(root, 'cat-file', 'commit', commit).split(b'\n\n', 1)
    metadata = [line for line in headers.splitlines() if line.startswith((b'author ', b'committer ', b'encoding '))]
    parents = [line.split()[1].decode() for line in headers.splitlines() if line.startswith(b'parent ')]
    return metadata, message, parents


def verify_mapping(source, candidate, mapping, paths, blobs):
    original = set(git(source, 'rev-list', 'HEAD').decode().splitlines())
    current = set(git(candidate, 'rev-list', '--all').decode().splitlines())
    if set(mapping) != original or set(mapping.values()) != current or len(current) != len(original):
        raise ValueError('The cleanup dropped, duplicated or introduced historical commits.')
    for old, new in mapping.items():
        author, message, parents = commit_data(source, old)
        rewritten_author, rewritten_message, rewritten_parents = commit_data(candidate, new)
        if (author, message, [mapping[p] for p in parents]) != (rewritten_author, rewritten_message, rewritten_parents):
            raise ValueError('Commit authorship, dates, message or parent order changed: ' + old)
        expected = {p: entry for p, entry in tree(source, old).items() if p not in paths and entry[2] not in blobs}
        if tree(candidate, new) != expected:
            raise ValueError('A historical tree changed outside the reviewed removal list: ' + old)
    return len(original)


def history_guard(root):
    paths, blobs = load_policy(root)
    for line in git(root, 'rev-list', '--objects', '--all').splitlines():
        oid, _, name = line.partition(b' ')
        if oid.decode() in blobs or name in paths:
            raise ValueError('Restricted file content remains reachable in Git history.')
    # Every path version, including aliases hidden by rev-list's single-name output, is checked.
    for commit in git(root, 'rev-list', '--all').decode().splitlines():
        if any(path in paths or value[2] in blobs for path, value in tree(root, commit).items()):
            raise ValueError('Restricted path remains in a historical tree.')


def prepare(root, output, scanner, filter_repo):
    private = (root / '.local').resolve()
    output = output.resolve()
    if output == private or not output.is_relative_to(private) or output.exists():
        raise ValueError('Choose a new output directory below this repository .local; existing files are never overwritten.')
    backup = output.with_name(output.name + '.before.bundle')
    receipt_path = output.with_name(output.name + '.receipt.json')
    if backup.exists() or receipt_path.exists():
        raise ValueError('Backup or receipt already exists; choose a new candidate name.')
    if git(root, 'diff', '--cached', '--name-only').strip():
        raise ValueError('Commit the intended release changes first; staged edits are not exported.')
    source_head = git(root, 'rev-parse', 'HEAD').decode().strip()
    if set(git(root, 'rev-list', '--all').splitlines()) != set(git(root, 'rev-list', 'HEAD').splitlines()):
        raise ValueError('Other refs contain unmerged history; review their release scope first.')
    paths, blobs = load_policy(root)
    output.parent.mkdir(parents=True, exist_ok=True)
    git(root, 'bundle', 'create', str(backup), 'HEAD')
    git(root, 'bundle', 'verify', str(backup))
    branch = git(root, 'symbolic-ref', '--short', 'HEAD').decode().strip()
    subprocess.run(['git', 'clone', '--quiet', '--no-local', '--single-branch', '--branch', branch, str(root), str(output)], check=True)
    # Use literal exact paths, plus content IDs to catch the same binary at renamed paths.
    path_file = output.parent / (output.name + '.removed-paths.txt')
    blob_file = output.parent / (output.name + '.removed-blobs.txt')
    path_file.write_bytes(b''.join(b'literal:' + p + b'\n' for p in sorted(paths)))
    blob_file.write_text('\n'.join(sorted(blobs)) + '\n')
    log = output.parent / (output.name + '.filter.log')
    with log.open('wb') as handle:
        subprocess.run([filter_repo, '--paths-from-file', str(path_file), '--invert-paths',
                        '--strip-blobs-with-ids', str(blob_file), '--prune-empty', 'never',
                        '--prune-degenerate', 'never', '--preserve-commit-hashes', '--preserve-commit-encoding'],
                       cwd=output, stdout=handle, stderr=subprocess.STDOUT, check=True)
    subprocess.run(['git', 'branch', '-M', 'main'], cwd=output, check=True)
    mapping = dict(line.split() for line in (output / '.git/filter-repo/commit-map').read_text().splitlines()[1:])
    count = verify_mapping(root, output, mapping, paths, blobs)
    history_guard(output)
    if git(output, 'remote').strip() or git(output, 'for-each-ref', '--format=%(refname)', 'refs/heads').strip() != b'refs/heads/main':
        raise ValueError('Candidate must have one main branch and no configured remote.')
    remaining = git(output, 'cat-file', '--batch-check', data=('\n'.join(sorted(blobs)) + '\n').encode())
    if any(not line.endswith(b' missing') for line in remaining.splitlines()):
        raise ValueError('Removed binary objects are still present in the candidate object database.')
    for command in ([sys.executable, 'scripts/check_public_source.py'],
                    [sys.executable, 'scripts/asset_inventory.py', '--check', '--require-reviewed'],
                    [scanner, 'dir', str(output), '--config', str(output / '.gitleaks.toml'), '--redact=100', '--no-banner'],
                    [scanner, 'git', '--log-opts=--all', '--config', str(output / '.gitleaks.toml'), '--redact=100', '--no-banner']):
        subprocess.run(command, cwd=output, check=True)
    if git(root, 'rev-parse', 'HEAD').decode().strip() != source_head:
        raise ValueError('Source HEAD changed during preparation; do not publish this candidate.')
    receipt = {'sourceCommit': source_head, 'candidateCommit': git(output, 'rev-parse', 'HEAD').decode().strip(),
               'commitsPreserved': count, 'allHistoricalTreesVerified': True, 'authorsDatesMessagesAndParentsPreserved': True,
               'removedPaths': len(paths), 'removedBlobIds': len(blobs), 'restrictedObjectsPhysicallyAbsent': True,
               'backupSha256': hashlib.sha256(backup.read_bytes()).hexdigest(),
               'historyAndSnapshotSecretScansPassed': True, 'sourceWorkingEditsIncluded': False,
               'candidateBranch': 'main', 'pushed': False, 'githubVisibilityChanged': False}
    receipt_path.write_text(json.dumps(receipt, indent=2) + '\n')
    return receipt


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Check all reachable history against the committed removal policy; no mutation.')
    parser.add_argument('--output', type=Path)
    parser.add_argument('--gitleaks')
    parser.add_argument('--filter-repo')
    args = parser.parse_args()
    if args.check:
        history_guard(ROOT)
        print('Restricted-file history guard passed.')
        return
    if not args.output or not args.gitleaks or not args.filter_repo:
        parser.error('--output, --gitleaks and --filter-repo are required for preparation.')
    scanner, filter_repo = shutil.which(args.gitleaks), shutil.which(args.filter_repo)
    if not scanner or not filter_repo:
        parser.error('Install Gitleaks and git-filter-repo before preparing a candidate.')
    os.umask(0o077)
    result = prepare(ROOT, ROOT / args.output, scanner, filter_repo)
    print('Verified history candidate:', result['commitsPreserved'], 'commits; original repository retained; no push or visibility change.')


if __name__ == '__main__':
    main()
