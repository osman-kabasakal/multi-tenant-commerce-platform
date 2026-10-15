#!/usr/bin/env python3
"""Exercise real storefront consent, tenant admin sending and private local notification capture."""
import argparse, hashlib, http.client, json, secrets, sys, urllib.parse
from html.parser import HTMLParser
from http.cookies import SimpleCookie
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
LOCAL=ROOT/'.local'

def check(condition,message):
    if not condition:raise RuntimeError(message)
    print('PASS:',message,flush=True)

class FormFields(HTMLParser):
    def __init__(self):super().__init__();self.values={}
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        if tag=='input' and attrs.get('type')=='hidden' and attrs.get('name'):self.values[attrs['name']]=attrs.get('value','')

class TenantClient:
    def __init__(self,port,slug,cookies=''):
        self.port=port;self.host=slug+'.localhost:'+str(port);self.cookies=SimpleCookie();self.cookies.load(cookies)
    def request(self,path,values=None):
        headers={'Host':self.host,'Cookie':'; '.join(key+'='+item.value for key,item in self.cookies.items())}
        body=None
        if values is not None:body=urllib.parse.urlencode(values);headers['Content-Type']='application/x-www-form-urlencoded'
        connection=http.client.HTTPConnection('127.0.0.1',self.port,timeout=30)
        try:
            connection.request('POST' if values is not None else 'GET',path,body,headers)
            response=connection.getresponse();page=response.read().decode()
            for key,value in response.getheaders():
                if key.lower()=='set-cookie':self.cookies.load(value)
            return response.status,page
        finally:connection.close()
    def form(self,path):
        status,page=self.request(path);check(status==200,'Tenant notification form loads through the actual web host (HTTP '+str(status)+')')
        fields=FormFields();fields.feed(page)
        check(bool(fields.values.get('__RequestVerificationToken')),'Notification form has a real antiforgery token')
        return fields.values

def check_tenant(account,slug,admin_cookie):
    configuration=json.loads((LOCAL/'commerce.json').read_text())
    check(configuration.get('Notifications',{}).get('Provider')=='LocalSink','Live notification test explicitly uses the local sink')
    routes=json.loads((LOCAL/'routes'/(slug+'.json')).read_text())
    tenant=routes['tenantId'];directory=LOCAL/'notifications'/tenant/'push'
    def capture():
        return {p.name:json.loads(p.read_text()) for p in directory.glob('*.json')}
    customer=TenantClient(18090,slug)
    fields=customer.form('/login')
    token='local-probe-'+secrets.token_hex(16);token_hash=hashlib.sha256(token.encode()).hexdigest()
    status,_=customer.request('/PushNotifications/ProcessRegistration',dict(fields,success='true',value=token))
    check(status==200,'Storefront records customer notification permission')
    admin=TenantClient(18083,slug,admin_cookie)
    status,settings_page=admin.request('/Admin/Setting/PushNotifications')
    check(status==200 and 'name="ServiceAccountFile"' not in settings_page and 'name="PrivateApiKey"' not in settings_page,'Tenant settings do not render private notification credential inputs')
    settings_fields=FormFields();settings_fields.feed(settings_page)
    status,_=admin.request('/Admin/Setting/PushNotifications',dict(settings_fields.values,PrivateApiKey='unsupported-local-probe'))
    check(status==400,'Tenant settings reject private server credential uploads')
    form=admin.form('/Admin/PushNotifications/Send')
    marker='Local notification '+secrets.token_hex(6);before=capture()
    status,_=admin.request('/Admin/PushNotifications/Send',dict(form,Title=marker,MessageText='Tenant notification smoke message',PictureId='',ClickUrl='http://'+slug+'.localhost:18090/'))
    check(status in (302,303),'Authenticated tenant administrator sends through the real notification action')
    current=capture();created=[data for name,data in current.items() if name not in before and data['message']['Title']==marker]
    check(created and any(token_hash in data['registrationTokenSha256'] for data in created),'Customer notification reaches its canonical tenant sink')
    check(all(data['tenantId']==tenant and token not in json.dumps(data) for data in created),'Captured messages keep tenant identity and omit raw device tokens')
    status,_=customer.request('/PushNotifications/ProcessRegistration',dict(fields,success='false',value='Permission denied'))
    check(status==200,'Customer can revoke notification permission through the storefront')
    before=set(capture());form=admin.form('/Admin/PushNotifications/Send')
    status,_=admin.request('/Admin/PushNotifications/Send',dict(form,Title=marker+' revoked',MessageText='Revoked-token check',PictureId='',ClickUrl=''))
    check(status in (302,303),'Tenant admin receives a response after consent revocation')
    created=[data for name,data in capture().items() if name not in before]
    check(all(token_hash not in data['registrationTokenSha256'] for data in created),'Revoked customer token receives no further notification')


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--fixture',default=str(LOCAL/'onboarding-smoke.json'));args=parser.parse_args()
    sys.path.insert(0,str(ROOT/'scripts'))
    from smoke_onboarding import administrator_session
    accounts=json.loads(Path(args.fixture).read_text())
    routes=[json.loads(path.read_text()) for path in (LOCAL/'routes').glob('*.json')]
    for account in accounts:
        tenant=account['registrationId'].replace('-','');route=next(r for r in routes if r['tenantId']==tenant)
        check_tenant(account,route['slug'],administrator_session(account,route['slug']))
    print('Local notification smoke checks passed.',flush=True)

if __name__=='__main__':
    try:main()
    except Exception as error:
        print('FAIL:',type(error).__name__,str(error)[:160],file=sys.stderr);sys.exit(1)
