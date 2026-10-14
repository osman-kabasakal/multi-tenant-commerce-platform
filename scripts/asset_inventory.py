#!/usr/bin/env python3
"""Record tracked assets and licensing inputs; inventory is evidence, not a license grant."""
import argparse
import csv
import hashlib
import io
import subprocess
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = {'.png', '.jpg', '.jpeg', '.gif', '.webp', '.svg', '.ico', '.ttf', '.otf', '.woff', '.woff2', '.eot', '.mp3', '.mp4', '.pdf', '.xlsx', '.xls', '.zip'}
MANIFESTS = {'package.json', 'package-lock.json', 'pubspec.yaml', 'pubspec.lock', 'Podfile.lock', 'Podfile', 'compose.yaml'}

def category(name):
    if '/assets/fonts/urbanist/' in name:
        return 'OFL-1.1', 'Platforms/store_user_app/assets/fonts/urbanist/OFL.txt'
    if '/Theme.Modern/Content/css/fonts/Poppins-' in name:
        return 'OFL-1.1', 'Ecommerce/src/Plugins/Theme.Modern/Content/css/fonts/OFL.txt'
    if '/simple-line-icons/' in name or name.endswith('/Simple-Line-Icons.ttf'):
        return 'review-redistribution-terms', 'docs/LICENSE_REVIEW.md#open-items'
    if '/kendo/' in name:
        return 'review-font-terms', 'docs/LICENSE_REVIEW.md#open-items'
    if name.endswith('/LineAwesome.ttf'):
        return 'review-derived-font-provenance', 'docs/LICENSE_REVIEW.md#open-items'
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
    args = parser.parse_args()
    names = sorted(filter(None, subprocess.check_output(['git', 'ls-files', '-z'], cwd=ROOT).decode().split('\0')))
    assets, inputs = [], []
    for name in names:
        path = ROOT / name
        if not path.is_file():
            continue
        is_asset = path.suffix.lower() in ASSETS or '/assets/lottie/' in name
        is_input = path.name in MANIFESTS or path.suffix in {'.csproj', '.props', '.podspec'} or path.name.endswith(('.gradle', '.gradle.kts')) or 'license' in path.name.lower() or 'notice' in path.name.lower()
        if not (is_asset or is_input) or name.startswith('docs/licenses/'):
            continue
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        if is_asset:
            assets.append((name, path.stat().st_size, digest, *category(name)))
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

if __name__ == '__main__':
    main()
