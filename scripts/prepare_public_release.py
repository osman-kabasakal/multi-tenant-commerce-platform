#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-only
"""Export the reviewed staged tree into a new, history-free local candidate."""
import argparse
import io
import json
import shutil
import subprocess
import sys
import tarfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def run(command, directory):
    subprocess.run(command, cwd=directory, check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True,
                        help='New directory under this repository .local; never overwritten')
    parser.add_argument('--gitleaks', required=True,
                        help='Installed Gitleaks executable; required, never skipped')
    args = parser.parse_args()
    output = (ROOT / args.output).resolve()
    private_root = (ROOT / '.local').resolve()
    if not output.is_relative_to(private_root) or output == private_root:
        parser.error('Output must be a new directory under this repository .local')
    if output.exists():
        parser.error('Output already exists; review it or choose a new candidate directory')
    scanner = shutil.which(args.gitleaks)
    if not scanner:
        parser.error('Gitleaks executable was not found')
    scanner = str(Path(scanner).resolve())
    run([sys.executable, 'scripts/asset_inventory.py', '--index', '--check', '--require-reviewed'], ROOT)
    tree = subprocess.check_output(['git', 'write-tree'], cwd=ROOT, text=True).strip()
    archive = subprocess.check_output(['git', 'archive', '--format=tar', tree], cwd=ROOT)
    output.mkdir(parents=True)
    with tarfile.open(fileobj=io.BytesIO(archive)) as snapshot:
        for member in snapshot.getmembers():
            target = (output / member.name).resolve()
            if not target.is_relative_to(output) or not (member.isfile() or member.isdir()):
                raise ValueError('Unsupported path or link in staged source: ' + member.name)
        # All member paths/types were checked; works with Python 3.10 as well.
        snapshot.extractall(output)
    run(['git', '-c', 'init.templateDir=', 'init', '--initial-branch=main', '--quiet'], output)
    run(['git', 'add', '--all'], output)
    run([sys.executable, 'scripts/check_public_source.py'], output)
    run([sys.executable, 'scripts/asset_inventory.py', '--check', '--require-reviewed'], output)
    run([scanner, 'dir', str(output), '--config', str(output / '.gitleaks.toml'),
         '--redact', '--no-banner'], output)
    receipt = {'sourceTree': tree, 'candidate': str(output),
               'originalHistoryIncluded': False, 'commitCreated': False,
               'pushed': False, 'checks': ['asset-provenance', 'source-filenames', 'gitleaks']}
    (output.parent / (output.name + '.receipt.json')).write_text(json.dumps(receipt, indent=2) + '\n')
    print('Local source candidate verified; no commit, push or visibility change:', output)


if __name__ == '__main__':
    main()
