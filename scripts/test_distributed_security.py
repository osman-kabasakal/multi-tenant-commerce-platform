#!/usr/bin/env python3
"""Use a disposable test database on the demo PostgreSQL; never reset application databases."""
import json, os, secrets, subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
local=ROOT/'.local'
config=json.loads((local/'saas.json').read_text())
name='security_test_'+secrets.token_hex(6)
config['PlatformSecurity']['ConnectionString']=config['PlatformSecurity']['ConnectionString'].replace('Database=commerce_secrets;',f'Database={name};')
config['PlatformSecurity']['InitializeSchema']=True
path=local/(name+'.json')
command=['docker','compose','--env-file',str(local/'compose.env'),'-f',str(ROOT/'compose.yaml'),'exec','-T','postgres']
os.umask(0o077)
subprocess.run(command+['createdb','-U','commerce_demo',name],check=True)
try:
    path.write_text(json.dumps(config))
    subprocess.run(['dotnet','run','--project',str(ROOT/'tests/DistributedSecurity/DistributedSecurity.csproj'),'-c','Release','--',str(path)],cwd=ROOT,check=True)
finally:
    path.unlink(missing_ok=True)
    subprocess.run(command+['dropdb','-U','commerce_demo',name],check=True)
