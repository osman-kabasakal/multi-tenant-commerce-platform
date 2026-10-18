#!/usr/bin/env python3
"""Record tracked assets and licensing inputs; inventory is evidence, not a license grant."""
import argparse
import csv
import hashlib
import io
import json
import subprocess
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = {'.png', '.jpg', '.jpeg', '.gif', '.webp', '.svg', '.ico', '.ttf', '.otf', '.woff', '.woff2', '.eot', '.mp3', '.mp4', '.pdf', '.xlsx', '.xls', '.zip'}
MANIFESTS = {'package.json', 'package-lock.json', 'pubspec.yaml', 'pubspec.lock', 'Podfile.lock', 'Podfile', 'compose.yaml', '.terraform.lock.hcl'}

def category(name, digest, provenance):
    entry = provenance.get(name)
    if entry:
        if entry['sha256'] != digest:
            raise SystemExit(f'Asset changed without updated provenance: {name}')
        evidence = ROOT / entry['evidence']
        if not evidence.is_file():
            raise SystemExit(f'Missing asset license evidence or retention record: {name}')
        if entry.get('method') == 'retained-existing-asset-user-direction':
            return 'retained:license-unconfirmed', entry['evidence']
        return 'evidenced:' + entry['license'], entry['evidence']
    return 'review-provenance', 'docs/LICENSE_REVIEW.md#open-items'


def render(fields, rows):
    out = io.StringIO(newline='')
    writer = csv.writer(out, lineterminator='\n')
    writer.writerow(fields)
    writer.writerows(rows)
    return out.getvalue()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    parser.add_argument('--index', action='store_true', help='Hash staged blobs, without unrelated working-tree edits')
    parser.add_argument('--require-reviewed', action='store_true', help='Require license evidence or an explicit existing-asset retention decision')
    args = parser.parse_args()
    names = sorted(filter(None, subprocess.check_output(['git', 'ls-files', '-z'], cwd=ROOT).decode().split('\0')))
    assets, inputs = [], []
    provenance = json.loads((ROOT / 'docs/licenses/provenance.json').read_text())['files']
    for name in names:
        path = ROOT / name
        if not path.is_file():
            continue
        is_asset = path.suffix.lower() in ASSETS or '/assets/lottie/' in name
        is_input = path.name in MANIFESTS or path.suffix in {'.csproj', '.props', '.podspec', '.tf'} or path.name.endswith(('.gradle', '.gradle.kts')) or 'license' in path.name.lower() or 'notice' in path.name.lower() or path.name == 'OFL.txt' or name.startswith('docs/licenses/upstream/') or name in {'docs/licenses/provenance.json', 'docs/licenses/replacements.json', 'docs/licenses/ASSET_RETENTION.md'}
        if not (is_asset or is_input) or name in {'docs/licenses/assets.csv', 'docs/licenses/inputs.csv'}:
            continue
        data = subprocess.check_output(['git', 'show', ':' + name], cwd=ROOT) if args.index else path.read_bytes()
        digest = hashlib.sha256(data).hexdigest()
        if is_asset:
            assets.append((name, len(data), digest, *category(name, digest, provenance)))
        if is_input:
            inputs.append((digest, name))
    outputs = {
        'docs/licenses/assets.csv': render(['path', 'bytes', 'sha256', 'status', 'evidence'], assets),
        'docs/licenses/inputs.csv': render(['sha256', 'path'], inputs),
    }
    for name, content in outputs.items():
        path = ROOT / name
        if args.check:
            if not path.exists() or path.read_text() != content:
                raise SystemExit(f'{name} is stale; stage source changes and run python3 scripts/asset_inventory.py')
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content)
    print(f'{len(assets)} asset paths; {len({r[2] for r in assets})} unique SHA-256 values; {len(inputs)} licensing inputs.')
    print(dict(Counter(r[3] for r in assets)))
    if args.require_reviewed and any(r[3].startswith('review-') for r in assets):
        raise SystemExit('Public release blocked: unresolved asset provenance; see docs/LICENSE_REVIEW.md')

if __name__ == '__main__':
    main()
