"""Actual Production SaaS enrollment helpers; only synthetic owners/private fixture configuration."""
import copy, http.cookiejar, json, ssl, time, uuid, urllib.error, urllib.parse, urllib.request
from html.parser import HTMLParser
from smoke_onboarding import LoginForm, NoRedirect, check

class CallbackForm(HTMLParser):
    def __init__(self,portal):super().__init__();self.expected=portal+'/remote-auth/signin-oidc';self.action=None;self.fields={};self.active=False
    def handle_starttag(self,tag,attributes):
        attributes=dict(attributes)
        if tag=='form' and attributes.get('action')==self.expected:self.action=self.expected;self.active=True
        if tag=='input' and self.active and attributes.get('name'):self.fields[attributes['name']]=attributes.get('value','')
    def handle_endtag(self,tag):
        if tag=='form':self.active=False

def browser(proxy,root,jar=None,redirect=True):
    handlers=[urllib.request.ProxyHandler({'https':proxy}),urllib.request.HTTPSHandler(context=ssl.create_default_context(cafile=str(root))),urllib.request.HTTPCookieProcessor(jar if jar is not None else http.cookiejar.CookieJar())]
    if not redirect:handlers.append(NoRedirect())
    return urllib.request.build_opener(*handlers)

def api(opener,portal,path,data=None,csrf=None):
    headers={'X-Requested-With':'XMLHttpRequest'};body=None
    if data is not None:body=json.dumps(data).encode();headers['Content-Type']='application/json'
    if csrf:headers['X-XSRF-TOKEN']=csrf
    try:response=opener.open(urllib.request.Request(portal+path,body,headers),timeout=30)
    except urllib.error.HTTPError as error:response=error
    with response:
        payload=response.read()
        try:value=json.loads(payload) if payload else None
        except ValueError:value=None
        return response.code,value

def enroll(portal,identity,proxy,tenants,password):
    anonymous=browser(proxy,identity['root'],redirect=False)
    check(api(anonymous,portal,'/api/TrialBusinesses/availability')==(200,{'enabled':True}),'Production portal explicitly advertises the configured trial offer')
    check(api(anonymous,portal,'/api/TrialBusinesses/configuration')[0] in (401,403),'Anonymous callers cannot access trial configuration or its antiforgery token')
    sessions=[]
    for index,(account,tenant) in enumerate(zip(identity['accounts'],tenants)):
        jar=http.cookiejar.CookieJar();opener=browser(proxy,identity['root'],jar)
        with opener.open(portal+'/api/Auth/login?returnUrl=/register',timeout=30) as response:form=LoginForm();form.feed(response.read().decode())
        check(bool(form.action) and form.action.startswith(identity['authority']+'/'),'Trial owner reaches the actual HTTPS identity login')
        values=dict(form.fields,username=account['username'],password=account['password'])
        with opener.open(urllib.request.Request(form.action,urllib.parse.urlencode(values).encode(),{'Content-Type':'application/x-www-form-urlencoded'}),timeout=30) as response:callback=CallbackForm(portal);callback.feed(response.read().decode())
        check(bool(callback.action) and 'state' in callback.fields,'Production identity returns the protected same-portal form callback')
        with opener.open(urllib.request.Request(callback.action,urllib.parse.urlencode(callback.fields).encode(),{'Content-Type':'application/x-www-form-urlencoded'}),timeout=30) as response:response.read()
        authenticated=browser(proxy,identity['root'],jar,redirect=False)
        code,session=api(authenticated,portal,'/api/Auth/sessionInfo');check(code==200 and session['data']['user']['email']==account['email'] and not session['data']['registrationStep']['isCompleted'],'Ordinary SaaS session recognizes the verified owner and an incomplete trial setup')
        code,configuration=api(authenticated,portal,'/api/TrialBusinesses/configuration');check(code==200 and configuration['plan']['trialDays']==14 and configuration['requestToken'],'Authenticated owner receives the explicit public plan and real antiforgery token')
        body={'registrationId':str(uuid.UUID(tenant)),'adminPassword':password,'business':{'name':'portable-'+tenant[:10],'legalCompanyName':'Portable Fixture Company '+str(index),'ownerName':'Portable Probe','taxNumber':'999999990'+str(index+1),'taxOffice':'Fixture Office','phone':'5551234567','address':'Fixture Company Street 10','city':'Fixture City','district':'Fixture District','postalCode':'00000'}}
        check(api(authenticated,portal,'/api/TrialBusinesses',body)[0]==400,'Production enrollment rejects a missing antiforgery token')
        invalid=copy.deepcopy(body);invalid['business']['phone']='1'
        check(api(authenticated,portal,'/api/TrialBusinesses',invalid,configuration['requestToken'])[0]==400,'Production enrollment rejects incomplete company contact data before persistence')
        code,result=api(authenticated,portal,'/api/TrialBusinesses',body,configuration['requestToken']);check(code==200 and result['businessId'].replace('-','')==tenant,'Actual Production SaaS creates the business/trial and queues its owned tenant')
        code,current=api(authenticated,portal,'/api/TrialBusinesses/configuration');ends=current['business']['trialEndsAt'];check(code==200 and current['business']['id'].replace('-','')==tenant and ends,'The trial expiration is persisted and visible to its owner')
        code,replayed=api(authenticated,portal,'/api/TrialBusinesses',body,configuration['requestToken']);check(code==200 and replayed['businessId']==result['businessId'],'Repeating the same Production enrollment preserves the business and its queue request')
        code,current=api(authenticated,portal,'/api/TrialBusinesses/configuration');check(code==200 and current['business']['trialEndsAt']==ends,'Enrollment replay does not extend or duplicate the configured trial period')
        changed=copy.deepcopy(body);changed['business']['address']='Changed Fixture Company Street'
        check(api(authenticated,portal,'/api/TrialBusinesses',changed,configuration['requestToken'])[0]==409,'An enrollment replay cannot silently change company details')
        sessions.append((authenticated,configuration['requestToken'],result,body))
    return sessions

def verify(portal,sessions):
    for opener,_,result,_ in sessions:
        deadline=time.monotonic()+45
        while time.monotonic()<deadline:
            code,configuration=api(opener,portal,'/api/TrialBusinesses/configuration')
            if code==200 and configuration['business'].get('databaseReady'):break
            time.sleep(.5)
        check(code==200 and configuration['business'].get('databaseReady'),'Production SaaS durably reconciles the actual worker completion and ready database')
        code,job=api(opener,portal,result['statusUrl']);check(code==200 and job['state']=='Succeeded' and job['steps']['publication']['resources']['readiness']=='Verified','The ordinary owner-only SaaS status endpoint reports verified Production publication')
        check('mongodb://' not in json.dumps(job) and 'adminPassword' not in json.dumps(job),'Owner job status contains no database credential or administrator password')
        code,session=api(opener,portal,'/api/Auth/sessionInfo');check(code==200 and session['data']['user']['isSetupCompleted'] and session['data']['registrationStep']['isCompleted'],'Ordinary Production SaaS session recognizes the completed trial without invoking paid registration')
    foreign,csrf,_,_=sessions[1];_,_,first,body=sessions[0]
    check(api(foreign,portal,first['statusUrl'])[0] in (401,403),'Another Production owner cannot read the first tenant setup job')
    check(api(foreign,portal,first['statusUrl']+'/retry',{},csrf)[0] in (401,403),'Another Production owner cannot retry the first tenant job')
    check(api(foreign,portal,'/api/TrialBusinesses',body,csrf)[0] in (401,403),'Another authenticated owner cannot adopt a foreign registration id')
