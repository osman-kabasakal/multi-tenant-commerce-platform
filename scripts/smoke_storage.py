#!/usr/bin/env python3
"""Real SaaS OIDC/private-file checks; synthetic transport bytes are not a mobile build."""
import argparse, base64, json, os, subprocess, sys, urllib.error, urllib.request, uuid
from pathlib import Path
import demo
from smoke_onboarding import NoRedirect, api, check, signed_in

PNG=base64.b64decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=')
BUILD=b'PLATFORM_STORAGE_SMOKE_ONLY_NOT_AN_APK\n'

def request(opener,path,body=None,headers=None):
    try:
        with opener.open(urllib.request.Request('http://localhost:18081'+path,body,headers or {}),timeout=30) as response:
            return response.status,dict(response.headers),response.read()
    except urllib.error.HTTPError as error:return error.code,dict(error.headers),error.read()

def upload(opener,app,csrf=None,payload=PNG):
    boundary='platform-smoke-'+uuid.uuid4().hex;parts=[]
    for key,value in {'businessAppId':app,'assetType':'Logo','platform':'android'}.items():
        parts.append(('--'+boundary+'\r\nContent-Disposition: form-data; name="'+key+'"\r\n\r\n'+value+'\r\n').encode())
    parts.append(('--'+boundary+'\r\nContent-Disposition: form-data; name="file"; filename="smoke.png"\r\nContent-Type: image/png\r\n\r\n').encode()+payload+b'\r\n')
    parts.append(('--'+boundary+'--\r\n').encode())
    headers={'Content-Type':'multipart/form-data; boundary='+boundary}
    if csrf:headers['X-XSRF-TOKEN']=csrf
    code,_,body=request(opener,'/api/uploads/app-asset',b''.join(parts),headers)
    return code,json.loads(body) if body and code==200 else None

def main():
    os.umask(0o077)
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--fixture',default=str(demo.LOCAL/'onboarding-smoke.json'));args=parser.parse_args()
    fixture=Path(args.fixture).resolve()
    if not fixture.is_relative_to(demo.LOCAL.resolve()):raise RuntimeError('Use an ignored local onboarding fixture.')
    accounts=json.loads(fixture.read_text());check(len(accounts)==2,'Two synthetic local onboarding owners are available')
    sessions=[];assets=[]
    for account in accounts:
        _,jar=signed_in(account);opener=urllib.request.build_opener(urllib.request.HTTPCookieProcessor(jar),NoRedirect())
        code,configuration=api(opener,'/api/LocalBusinesses/configuration')
        check(code==200 and configuration.get('requestToken'),'Owner receives a real antiforgery token')
        code,vm=api(opener,'/api/app-builds/get-vm')
        check(code==200 and vm['isSuccess'] and uuid.UUID(vm['data']['businessAppId']).int!=0,'Owner resolves the own mobile application')
        app=vm['data']['businessAppId'];csrf=configuration['requestToken']
        code,_=upload(opener,app)
        check(code==400,'Multipart upload rejects a missing antiforgery token')
        code,invalid=upload(opener,app,csrf,b'not-an-image')
        check(code==200 and not invalid['isSuccess'],'Image upload rejects a forged content signature')
        code,result=upload(opener,app,csrf)
        check(code==200 and result['isSuccess'],'Owner uploads a private image through the real SaaS endpoint')
        asset=result['data']['url'];check(asset.startswith('/api/uploads/app-asset/file?assetId=') and 'pfile:' not in json.dumps(result),'Upload exposes an authenticated asset reference without backend paths')
        code,headers,content=request(opener,asset)
        check(code==200 and content==PNG and headers.get('Content-Type')=='image/png','Owner downloads the exact private image bytes')
        check('no-store' in headers.get('Cache-Control','') and headers.get('X-Content-Type-Options')=='nosniff','Private downloads carry cache and content-type protections')
        sessions.append((opener,app,csrf));assets.append(asset)
    for index in range(2):
        opener,_,csrf=sessions[index];other=1-index
        check(request(opener,assets[other])[0]==404,'A different business owner cannot download the private image')
        code,denied=upload(opener,sessions[other][1],csrf)
        check(code==200 and not denied['isSuccess'],'A different business owner cannot upload into the application')
    anonymous=urllib.request.build_opener(NoRedirect())
    code,_,body=request(anonymous,assets[0]);check(code in (401,403,302) and body!=PNG,'Anonymous requests cannot obtain private image content')
    project=demo.ROOT/'tests/Portable.Services.Integration/Portable.Services.Integration.csproj'
    with (demo.LOCAL/'logs/build-storage-fixture.log').open('w') as log:
        subprocess.run(['dotnet','build',str(project),'-c','Release','--nologo'],cwd=demo.ROOT/'SaasManager',stdout=log,stderr=subprocess.STDOUT,check=True)
    dll=project.parent/'bin/Release/net9.0/Portable.Services.Integration.dll'
    result=subprocess.run(['dotnet',str(dll),str(demo.LOCAL/'saas.json'),sessions[0][1]],cwd=demo.ROOT/'SaasManager',text=True,capture_output=True)
    (demo.LOCAL/'logs/storage-fixture.log').write_text(result.stderr)
    if result.returncode:raise RuntimeError('Synthetic build fixture failed; inspect the private test log.')
    build_id=json.loads(result.stdout)['buildId'];path='/api/app-builds/download?appBuildId='+build_id
    code,headers,body=request(sessions[0][0],path)
    check(code==200 and body==BUILD,'SaaS streams exact build bytes written by an independent process')
    check('no-store' in headers.get('Cache-Control','') and 'attachment' in headers.get('Content-Disposition',''),'Build download uses a private attachment response')
    code,headers,body=request(sessions[0][0],path,headers={'Range':'bytes=0-15'})
    check(code==206 and body==BUILD[:16] and headers.get('Content-Range','').startswith('bytes 0-15/'),'Build streaming supports bounded HTTP range downloads')
    check(request(sessions[1][0],path)[0]==404,'A different business owner cannot download the build')
    check(request(anonymous,path)[0] in (401,403,302),'Anonymous requests cannot obtain the build')
    print('Private SaaS storage HTTP checks passed; synthetic bytes do not validate a mobile build.',flush=True)

if __name__=='__main__':
    try:main()
    except Exception as error:
        print('FAIL:',type(error).__name__,str(error)[:160],file=sys.stderr);sys.exit(1)
