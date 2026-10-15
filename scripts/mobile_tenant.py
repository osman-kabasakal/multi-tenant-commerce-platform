#!/usr/bin/env python3
"""Generate public-only Flutter debug defines for a provisioned local tenant."""
import argparse,json,os,re,urllib.parse
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('slug')
    parser.add_argument('--base-url',default='http://127.0.0.1:18090',help='Use adb reverse, or http://10.0.2.2:18090 for an Android emulator.')
    args=parser.parse_args()
    if not re.fullmatch(r'[a-z][a-z0-9-]{1,38}[a-z0-9]',args.slug):parser.error('Use the provisioned tenant slug.')
    uri=urllib.parse.urlparse(args.base_url)
    if uri.scheme!='http' or uri.hostname not in ('localhost','127.0.0.1','10.0.2.2','::1') or uri.username or uri.password or uri.query or uri.fragment:
        parser.error('Local debug builds require a local HTTP gateway URL.')
    manifest=json.loads((ROOT/'.local/mobile'/(args.slug+'.json')).read_text())
    if manifest.get('slug')!=args.slug or manifest.get('localDemo') is not True or manifest.get('firebase',{}).get('enabled') is not False:
        parser.error('This generator accepts an explicit local demo manifest only.')
    defines={'LOCAL_DEMO':'true','LOCAL_TENANT_HOST':args.slug+'.localhost:18090','STORE_URL':args.base_url.rstrip('/'),
        'APP_TITLE':manifest['displayName'],'PACKAGE_NAME_ANDROID':manifest['androidApplicationId'],'PACKAGE_NAME_IOS':manifest['iosBundleId']}
    os.umask(0o077)
    output=ROOT/'.local/mobile'/(args.slug+'.defines.json');output.write_text(json.dumps(defines,indent=2));output.chmod(0o600)
    print(output)
if __name__=='__main__':main()
