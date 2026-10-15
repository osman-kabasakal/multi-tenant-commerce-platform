#!/usr/bin/env python3
"""Real OIDC enrollment, two tenant installs and cross-tenant checks. Never prints credentials."""
import argparse, http.cookiejar, json, os, secrets, subprocess, sys, time, urllib.error, urllib.parse, urllib.request, uuid
from html.parser import HTMLParser
from http.cookies import SimpleCookie
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
import demo
import smoke
import smoke_notifications

class LoginForm(HTMLParser):
    def __init__(self):super().__init__();self.action=None;self.fields={};self.active=False
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        if tag=='form' and attrs.get('id')=='kc-form-login':self.action=attrs.get('action');self.active=True
        if tag=='input' and self.active and attrs.get('name') and attrs.get('type')=='hidden':self.fields[attrs['name']]=attrs.get('value','')
    def handle_endtag(self,tag):
        if tag=='form':self.active=False

class LocalBrowserCookiePolicy(http.cookiejar.DefaultCookiePolicy):
    # Keycloak marks localhost cookies Secure. Emulate the browser localhost exception in this HTTP test client.
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie#secure
    def return_ok_secure(self,cookie,request):
        if urllib.parse.urlparse(request.full_url).hostname=='localhost' and cookie.domain in ('localhost','localhost.local'):
            return True
        return super().return_ok_secure(cookie,request)

class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self,*args,**kwargs):return None

def check(condition,message):
    if not condition:raise RuntimeError(message)
    print('PASS:',message,flush=True)

def signed_in(account):
    jar=http.cookiejar.CookieJar(policy=LocalBrowserCookiePolicy());opener=urllib.request.build_opener(urllib.request.HTTPCookieProcessor(jar))
    with opener.open('http://localhost:18081/api/Auth/login?returnUrl=/local-onboarding.html',timeout=30) as response:
        form=LoginForm();form.feed(response.read().decode())
    check(bool(form.action) and urllib.parse.urlparse(form.action).netloc=='localhost:18080','OIDC presents the local Keycloak login form')
    values=dict(form.fields,username=account['username'],password=account['password'])
    with opener.open(urllib.request.Request(form.action,urllib.parse.urlencode(values).encode(),{'Content-Type':'application/x-www-form-urlencoded'}),timeout=30) as response:
        check(response.geturl().startswith('http://localhost:18081/'),'OIDC returns to SaaS after real user authentication')
        response.read()
    return opener,jar

def api(opener,path,data=None,csrf=None):
    headers={};body=None
    if data is not None:headers['Content-Type']='application/json';body=json.dumps(data).encode()
    if csrf:headers['X-XSRF-TOKEN']=csrf
    request=urllib.request.Request('http://localhost:18081'+path,body,headers)
    try:
        with opener.open(request,timeout=30) as response:return response.status,json.load(response)
    except urllib.error.HTTPError as error:
        return error.code,None

def administrator_session(account,slug):
    host=slug+'.localhost:18083';cookies=SimpleCookie()
    def request(path,method='GET',body=None):
        headers={'Cookie':'; '.join(key+'='+item.value for key,item in cookies.items())}
        if body is not None:headers['Content-Type']='application/x-www-form-urlencoded'
        code,response_headers,page=smoke.request(18083,path,host,method=method,body=body,extra_headers=headers)
        if response_headers.get('Set-Cookie'):cookies.load(response_headers['Set-Cookie'])
        return code,response_headers,page
    code,headers,_=request('/Admin')
    location=urllib.parse.urlparse(headers['Location']);path=location.path+('?' +location.query if location.query else '')
    code,_,page=request(path)
    class Fields(HTMLParser):
        def __init__(self):super().__init__();self.values={}
        def handle_starttag(self,tag,attributes):
            attributes=dict(attributes)
            if tag=='input' and attributes.get('name') and attributes.get('type')=='hidden':self.values[attributes['name']]=attributes.get('value','')
    fields=Fields();fields.feed(page)
    values=dict(fields.values,Email=account['email'],Password=account['adminPassword'],RememberMe='false')
    code,headers,_=request('/admin/login','POST',urllib.parse.urlencode(values))
    check(code in (302,303) and 'login' not in headers.get('Location','').lower(),'Provisioned owner can sign into the actual tenant admin')
    target=urllib.parse.urlparse(headers['Location']);path=(target.path or '/Admin')+('?' +target.query if target.query else '')
    code,_,page=request(path)
    check(code==200 and 'logout' in page.lower(),'Authenticated tenant admin dashboard loads')
    return '; '.join(key+'='+item.value for key,item in cookies.items())

def main():
    os.umask(0o077)
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--fresh',action='store_true');args=parser.parse_args()
    fixture=demo.LOCAL/('onboarding-smoke-'+secrets.token_hex(4)+'.json' if args.fresh else 'onboarding-smoke.json')
    credentials=json.loads((demo.LOCAL/'credentials.json').read_text())
    admin=demo.request_json(demo.IDENTITY+'/realms/master/protocol/openid-connect/token',
        {'grant_type':'password','client_id':'admin-cli','username':'demo-admin','password':credentials['keycloak_admin']},form=True)['access_token']
    if fixture.exists():accounts=json.loads(fixture.read_text())
    else:
        accounts=[]
        for index in range(2):
            suffix=secrets.token_hex(4)
            accounts.append({'username':'enroll-'+suffix,'email':'enroll-'+suffix+'@example.test','password':secrets.token_urlsafe(24),
                'adminPassword':secrets.token_urlsafe(24),'businessName':'Onboarding '+suffix,'registrationId':str(uuid.uuid4())})
        demo.write_json(fixture,accounts)
    keycloak=demo.IDENTITY+'/admin/realms/commerce-demo'
    sessions=[]
    for account in accounts:
        existing=demo.request_json(keycloak+'/users?username='+account['username']+'&exact=true',bearer=admin)
        if not existing:
            demo.request_json(keycloak+'/users',{'username':account['username'],'email':account['email'],'firstName':'Demo','lastName':'Owner',
                'emailVerified':True,'enabled':True,'credentials':[{'type':'password','value':account['password'],'temporary':False}]},admin,'POST')
        opener,jar=signed_in(account)
        code,configuration=api(opener,'/api/LocalBusinesses/configuration')
        check(code==200 and configuration.get('requestToken'),'SaaS supplies an authenticated antiforgery token')
        body={'registrationId':account['registrationId'],'name':account['businessName'],'adminPassword':account['adminPassword']}
        code,_=api(opener,'/api/LocalBusinesses',body)
        check(code==400,'Enrollment rejects a missing antiforgery token')
        code,result=api(opener,'/api/LocalBusinesses',body,configuration['requestToken'])
        check(code==200 and result['businessId']==account['registrationId'],'SaaS persists a real local trial and queues its tenant')
        current_code,current_job=api(opener,result['statusUrl'])
        if current_code==200 and current_job['state']=='Failed':
            retry_code,_=api(opener,result['statusUrl']+'/retry',{},configuration['requestToken'])
            check(retry_code==200,'Existing failed setup can resume after its configuration is corrected')
        deadline=time.monotonic()+240
        job=None
        while time.monotonic()<deadline:
            code,job=api(opener,result['statusUrl'])
            if code!=200:raise RuntimeError('Provisioning state unavailable')
            if job['state']=='Succeeded':break
            if job['state']=='Failed':raise RuntimeError('Provisioning failed: '+str(job['errorCode']))
            time.sleep(2)
        check(job and job['state']=='Succeeded','Worker provisions database, store, identity and local publication')
        check(set(job['steps'])=={'tenant-secrets','database','store','identity','publication'},'Every configured onboarding step has a durable checkpoint')
        code,replayed=api(opener,'/api/LocalBusinesses',body,configuration['requestToken'])
        check(code==200 and replayed['businessId']==result['businessId'],'Repeated enrollment preserves the business and its resources')
        slug=result['slug'];host=slug+'.localhost:18090'
        status,_,page=smoke.request(18090,host=host)
        check(status==200 and account['businessName'] in page,'New tenant storefront works without a gateway restart')
        check(smoke.request(18090,'/'+slug+'-0',host=host)[0]==200,'New tenant product detail works')
        token=demo.request_json(demo.IDENTITY+'/realms/commerce-demo/protocol/openid-connect/token',
            {'grant_type':'client_credentials','client_id':slug,'client_secret':(demo.LOCAL/'secrets'/('ClientSecret-'+slug)).read_text()},form=True)['access_token']
        check(smoke.request(18082,'/health',host,token)[0]==200,'New tenant token is verified by commerce')
        check(smoke.request(18083,'/Admin',slug+'.localhost:18083')[0]==302,'New tenant admin requires login without an admin restart')
        public=json.dumps(job)
        check(account['adminPassword'] not in public and 'mongodb://' not in public,'Job status contains no administrator password or database connection')
        manifest=json.loads((demo.LOCAL/'mobile'/(slug+'.json')).read_text())
        check(manifest['baseUrl']==job['steps']['publication']['resources']['storeUrl'] and manifest['firebase']['enabled'] is False,'Local mobile configuration selects the new tenant and explicit cloud-free capabilities')
        check((demo.LOCAL/'notifications'/slug/'ready.json').is_file(),'Tenant readiness notification reaches the local sink')
        mobile_headers={'Accept':'application/json','X-Response-View':'Json','Content-Type':'application/json'}
        status,_,body=smoke.request(18090,'/TenantTokenWeb/guest',host,method='POST',body='',extra_headers=mobile_headers)
        check(status==200,'New tenant issues a mobile customer guest token')
        mobile_headers['Authorization']='Bearer '+json.loads(body)['AccessToken']
        status,_,body=smoke.request(18090,'/Component/HomePageProducts',host,extra_headers=mobile_headers)
        check(status==200 and isinstance(json.loads(body),list),'Mobile customer token loads the new tenant catalog')
        subprocess.run([sys.executable,str(demo.ROOT/'scripts/mobile_tenant.py'),slug],check=True,stdout=subprocess.DEVNULL)
        defines=json.loads((demo.LOCAL/'mobile'/(slug+'.defines.json')).read_text())
        check(defines['LOCAL_TENANT_HOST']==slug+'.localhost:18090' and not any('secret' in key.lower() for key in defines),'Flutter debug defines select the tenant without confidential credentials')
        for _ in range(20):
            code,ready=api(opener,'/api/LocalBusinesses/configuration')
            if code==200 and ready['business'].get('databaseReady'):break
            time.sleep(.5)
        check(ready['business']['databaseReady'] and ready['business']['status'] in (3,'Trial','trial'),'SaaS durably records the ready database and trial subscription state')
        session_code,session=api(opener,'/api/Auth/sessionInfo')
        check(session_code==200 and session['data']['user']['isSetupCompleted'] and session['data']['registrationStep']['isCompleted'],'Ordinary SaaS session recognizes the completed trial without card registration')
        account['slug']=slug;admin_cookie=administrator_session(account,slug);smoke_notifications.check_tenant(account,slug,admin_cookie);sessions.append((opener,jar,configuration['requestToken'],token,admin_cookie))
    # Independently authenticated owners must not see or retry each other's installation.
    foreign=urllib.request.build_opener(urllib.request.HTTPCookieProcessor(sessions[1][1]),NoRedirect())
    check(api(foreign,'/api/Provisioning/'+accounts[0]['registrationId'])[0] in (401,403),'Another owner cannot read the first tenant job')
    check(api(foreign,'/api/Provisioning/'+accounts[0]['registrationId']+'/retry',{},sessions[1][2])[0] in (401,403),'Another owner cannot retry the first tenant job')
    check(smoke.request(18082,'/',accounts[1]['slug']+'.localhost:18090',sessions[0][3])[0] in (400,401,403),'New tenant tokens cannot cross tenant hosts')
    check(smoke.request(18083,'/Admin',accounts[1]['slug']+'.localhost:18083',extra_headers={'Cookie':sessions[0][4]})[0] in (302,401,403),'Tenant admin authentication cannot cross tenant hosts')
    first=json.loads((demo.LOCAL/'tenants'/(accounts[0]['slug']+'.json')).read_text())
    second=json.loads((demo.LOCAL/'tenants'/(accounts[1]['slug']+'.json')).read_text())
    connection=first['connectionString'].replace('127.0.0.1:27028','127.0.0.1:27017')
    own_db=urllib.parse.urlparse(first['connectionString']).path[1:];other_db=urllib.parse.urlparse(second['connectionString']).path[1:]
    script='const tenant=new Mongo('+json.dumps(connection)+');\n'+'const own=tenant.getDB('+json.dumps(own_db)+');const other=tenant.getDB('+json.dumps(other_db)+');'+r"""
if (!own.Store.findOne()) throw Error('Own store missing');
let denied=false;try { other.Store.findOne(); } catch(error) { denied=error.code===13; }
if (!denied) throw Error('Cross-tenant database access was allowed');
print('DATABASE_ISOLATION_OK');
"""
    result=subprocess.run(['docker','compose','--env-file',str(demo.LOCAL/'compose.env'),'-f',str(demo.ROOT/'compose.yaml'),
        'exec','-T','mongo','mongosh','--quiet','--file','/dev/stdin'],input=script,text=True,capture_output=True)
    check(result.returncode==0 and 'DATABASE_ISOLATION_OK' in result.stdout,'Mongo credentials allow the own database and deny another tenant database')
    log=''.join(path.read_text(errors='replace') for path in (demo.LOCAL/'logs').glob('*.log') if not path.name.startswith('build-'))
    check(all(account['adminPassword'] not in log and account['password'] not in log for account in accounts),'Application logs contain no enrollment or login passwords')
    print('Local onboarding smoke checks passed.',flush=True)

if __name__=='__main__':
    try:main()
    except Exception as error:
        print('FAIL:',type(error).__name__,str(error)[:160],file=sys.stderr);sys.exit(1)
