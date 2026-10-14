#!/usr/bin/env python3
"""Live checks for the fixed local demo. Run after demo.py up. Never print credentials or tokens."""
import base64
import http.client
import json
import os
import subprocess
import sys
import urllib.parse
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
import demo

def request(port, path='/', host=None, token=None, method='GET', body=None, extra_headers=None):
    headers=dict(extra_headers or {})
    if host:headers['Host']=host
    if token:headers['x-store-token']=token
    connection=http.client.HTTPConnection('127.0.0.1',port,timeout=30)
    try:
        connection.request(method,path,body=body,headers=headers)
        response=connection.getresponse()
        # Preserve every Set-Cookie header when checking whether a callback issued a session.
        response_headers={}
        for name,value in response.getheaders():
            response_headers[name]=response_headers.get(name,'')+'\n'+value if name in response_headers else value
        return response.status,response_headers,response.read().decode(errors='replace')
    finally:connection.close()

def expect(condition, message):
    if not condition:raise AssertionError(message)
    print('PASS:',message)

def main():
    tokens={}
    for slug,own,other in [('demo-a','Demo Espresso','Demo Architecture Book'),('demo-b','Demo Architecture Book','Demo Espresso')]:
        token=demo.request_json(demo.IDENTITY+'/realms/commerce-demo/protocol/openid-connect/token',
            {'grant_type':'client_credentials','client_id':slug,'client_secret':(demo.LOCAL/'secrets'/('ClientSecret-'+slug)).read_text()},form=True)['access_token']
        tokens[slug]=token
        status,_,body=request(18090,host=slug+'.localhost:18090')
        expect(status==200 and own in body and other not in body,slug+' catalog is isolated')
        status,_,body=request(18090,'/'+slug+'-0',host=slug+'.localhost:18090')
        expect(status==200 and own in body,slug+' product detail loads')
        expect(request(18082,'/health',slug+'.localhost:18090',token)[0]==200,slug+' valid token accepted')
    # Exercise the same tenant-scoped guest token endpoints as the Flutter app.
    for slug,own in [('demo-a','Demo Espresso'),('demo-b','Demo Architecture Book')]:
        host=slug+'.localhost:18090'
        mobile_headers={'Accept':'application/json','X-Response-View':'Json','Content-Type':'application/json'}
        status,_,body=request(18090,'/TenantTokenWeb/guest',host,method='POST',body='',extra_headers=mobile_headers)
        expect(status==200,slug+' mobile guest token issued')
        mobile_headers['Authorization']='Bearer '+json.loads(body)['AccessToken']
        status,_,body=request(18090,'/Component/HomePageProducts',host,extra_headers=mobile_headers)
        expect(status==200 and own in body and isinstance(json.loads(body),list),slug+' mobile catalog accepts guest token')
        status,_,body=request(18090,'/ShoppingCart/Cart',host,extra_headers=mobile_headers)
        expect(status==200 and isinstance(json.loads(body),dict),slug+' mobile cart accepts guest token')
    expect(request(18082,'/', 'demo-a.localhost:18090')[0] in (400,401,403),'missing store token rejected')
    expect(request(18082,'/', 'demo-b.localhost:18090',tokens['demo-a'])[0] in (400,401,403),'token cannot cross tenants')
    parts=tokens['demo-a'].split('.');signature=parts[2];parts[2]=('A' if signature[0]!='A' else 'B')+signature[1:]
    expect(request(18082,'/', 'demo-a.localhost:18090','.'.join(parts))[0] in (400,401,403),'tampered signature rejected')
    expect(request(18090,host='unknown.localhost:18090')[0]==400,'unknown gateway host rejected')
    expect(request(18083,host='unknown.localhost:18083')[0]==400,'unknown admin host rejected')
    status,headers,_=request(18083,'/Admin','demo-a.localhost:18083')
    expect(status==302 and 'login' in headers.get('Location','').lower(),'admin requires login')
    expect(request(18081,'/health')[0]==200,'SaaS health')
    expect(request(18081,'/api/Auth/sessionInfo')[0] in (302,401),'SaaS session requires login')
    expect(request(18081,'/api/demo-disabled',method='POST',body='{}')[0]==409,'SaaS cloud/billing mutations disabled')
    status,headers,_=request(18081,'/api/Auth/login?returnUrl=/','localhost:18081')
    challenge=urllib.parse.urlparse(headers.get('Location',''))
    params=urllib.parse.parse_qs(challenge.query)
    expect(status==302 and challenge.netloc=='localhost:18080' and
           challenge.path=='/realms/commerce-demo/protocol/openid-connect/auth' and
           params.get('client_id')==['centraladminapp'] and bool(params.get('request_uri')),
           'SaaS login uses the local realm with pushed authorization')
    # A forged callback must not establish a session. ASP.NET handles protected state and correlation.
    status,headers,_=request(18081,'/remote-auth/signin-oidc?code=invalid&state=invalid')
    cookies=[cookie for name,value in headers.items() if name.lower()=='set-cookie' for cookie in value.splitlines()]
    expect(status in (302,400,500) and not any('auth.session=' in cookie and 'expires=Thu, 01 Jan 1970' not in cookie for cookie in cookies),
           'forged OIDC callback does not issue a session')
    # Verify local adapters cannot be enabled in Production, before any cloud or database call.
    for name in ('commerce','saas'):
        env=demo.app_env();env.update(ASPNETCORE_ENVIRONMENT='Production',DOTNET_ENVIRONMENT='Production')
        if name=='saas':env['LocalDemo__ConfigPath']=str(demo.LOCAL/'saas.json')
        runtime=demo.LOCAL/'runtime'/name
        result=subprocess.run(['dotnet',str(runtime/demo.PROJECTS[name][2])],cwd=runtime,env=env,capture_output=True,text=True,timeout=30)
        expect(result.returncode!=0 and 'Development' in result.stdout+result.stderr,name+' rejects LocalDemo in Production')
    print('All local smoke checks passed.')
if __name__=='__main__':
    try:main()
    except Exception as error:
        print('FAIL:',type(error).__name__,str(error)[:160],file=sys.stderr);sys.exit(1)
