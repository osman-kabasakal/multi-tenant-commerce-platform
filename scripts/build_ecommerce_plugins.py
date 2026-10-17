#!/usr/bin/env python3
"""Build every legacy-compatible plugin for an explicit GrandNode target."""
import argparse
from pathlib import Path
import subprocess
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[1]
BUILD_TYPES=('Frontend','Backend','Installer','Background','Uploader')

def projects(build_type):
    if build_type not in BUILD_TYPES: raise ValueError('Choose an explicit supported BuildType.')
    manifest=ET.parse(ROOT/'Ecommerce/src/Build/ManagedTenantPlugins.props').getroot()
    for entry in manifest.findall('./ItemGroup/ManagedTenantPlugin'):
        category=entry.findtext('Category')
        if category=='AdminPlugins' and build_type=='Frontend': continue
        name=entry.attrib['Include']
        yield ROOT/'Ecommerce/src'/category/name/(name+'.csproj')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--build-type',required=True,choices=BUILD_TYPES)
    parser.add_argument('--configuration',default='Release',choices=('Debug','Release'))
    args=parser.parse_args()
    for project in projects(args.build_type):
        print('Building '+project.stem+' for '+args.build_type,flush=True)
        subprocess.run(['dotnet','build',str(project),'-c',args.configuration,'-p:BuildType='+args.build_type,
                        '-p:CopyLocalLockFileAssemblies=true','--nologo','--verbosity','quiet'],cwd=ROOT,check=True)

if __name__=='__main__': main()
