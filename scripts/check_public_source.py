#!/usr/bin/env python3
"""Check the tracked snapshot for files that must never be published."""
import re
import subprocess
import sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
files=subprocess.check_output(['git','ls-files','-z'],cwd=ROOT).decode().split('\0')
forbidden=re.compile(r'(^|/)(\.local|\.codegraph|node_modules|bin|obj|build|Pods|\.dart_tool|\.playwright-cli)(/|$)|(^|/)(google-services\.json|GoogleService-Info\.plist|firebase_options\.dart|key\.properties|local\.properties|Generated\.xcconfig)$|\.(p8|p12|pfx|pem|key|jks|keystore|mobileprovision|mmdb)$|service[-_]?account.*\.json$',re.I)
errors=[]
for name in filter(None,files):
    if forbidden.search(name) and not name.startswith("Ecommerce/src/Build/"):errors.append(name)
    if '/wwwroot/assets/files/exportimport/' in name and Path(name).name != 'Index.htm':errors.append(name)
    if '/wwwroot/assets/images/uploaded/' in name and Path(name).name != 'placeholder.txt':errors.append(name)
    base=Path(name).name
    if (base=='.env' or base.startswith('.env.')) and base!='.env.example':errors.append(name)
if errors:
    print('Forbidden tracked files:\n'+'\n'.join(sorted(set(errors))),file=sys.stderr);sys.exit(1)
print('Tracked-source filename guard passed:',len(list(filter(None,files))),'files.')
