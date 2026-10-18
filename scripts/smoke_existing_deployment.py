#!/usr/bin/env python3
"""Verify an existing owned test tenant over real HTTPS, without provisioning resources."""
import argparse
import datetime
import http.cookiejar
import json
import os
import re
import ssl
import subprocess
import traceback
import urllib.error
import urllib.parse
import urllib.request
from html.parser import HTMLParser
from pathlib import Path

import portable_saas_enrollment as enrollment
import production
from oracle import private_path, save
from smoke_onboarding import LoginForm, NoRedirect


class Page(HTMLParser):
    def __init__(self):
        super().__init__()
        self.forms, self.assets, self.token, self.form = [], [], None, None

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == 'form':
            self.form = {'action': attrs.get('action', ''), 'fields': {}}
            self.forms.append(self.form)
        if tag == 'input' and attrs.get('name'):
            if self.form is not None and attrs.get('type') != 'checkbox':
                self.form['fields'][attrs['name']] = attrs.get('value', '')
            if attrs['name'] == '__RequestVerificationToken':
                self.token = attrs.get('value')
        asset = attrs.get('src') if tag == 'script' else attrs.get('href') if tag == 'link' and attrs.get('rel') == 'stylesheet' else None
        if asset:
            self.assets.append(asset)

    def handle_endtag(self, tag):
        if tag == 'form':
            self.form = None


def browser(redirect=True, jar=None):
    handlers = [urllib.request.ProxyHandler({}), urllib.request.HTTPSHandler(context=ssl.create_default_context()),
                urllib.request.HTTPCookieProcessor(jar if jar is not None else http.cookiejar.CookieJar())]
    if not redirect:
        handlers.append(NoRedirect())
    return urllib.request.build_opener(*handlers)


def request(opener, url, fields=None):
    body = None if fields is None else urllib.parse.urlencode(fields).encode()
    headers = {} if body is None else {'Content-Type': 'application/x-www-form-urlencoded'}
    try:
        response = opener.open(urllib.request.Request(url, body, headers), timeout=45)
    except urllib.error.HTTPError as error:
        response = error
    with response:
        return response.code, response.headers, response.read(), response.url


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--state', type=Path, required=True)
    parser.add_argument('--fixture', type=Path, required=True, help='Private existing test-owner fixture; never a customer password on the command line.')
    parser.add_argument('--receipt', type=Path, required=True)
    args = parser.parse_args()
    state = private_path(args.state, directory=True)
    fixture = json.loads(private_path(args.fixture).read_text())
    parent = private_path(args.receipt.parent, directory=True)
    receipt = parent / args.receipt.name
    if receipt.exists():
        private_path(receipt)
    tenant = fixture['tenant']
    assert re.fullmatch('[a-f0-9]{32}', tenant), 'Invalid owned fixture tenant.'
    for name in ('username', 'email', 'password', 'tenantPassword'):
        assert isinstance(fixture[name], str) and fixture[name], 'Missing private fixture field.'
    d = production.Deployment(state)
    d.owned_resources()
    d.verify_identity()
    d.verify_hosts()
    checks = []

    def check(condition, label):
        assert condition, label
        checks.append(label)
        print('PASS: ' + label, flush=True)

    expected = {name for name, service in d.definition['services'].items() if not service.get('profiles')}
    statuses = []

    def services_ready():
        nonlocal statuses
        output = d.run('ps', '--all', '--format', 'json', capture=True).stdout.strip()
        statuses = json.loads(output) if output.startswith('[') else [json.loads(line) for line in output.splitlines()]
        active = [item for item in statuses if item['Service'] in expected]
        return {item['Service'] for item in active if item['State'] == 'running'} == expected and all(item.get('Health') not in ('unhealthy', 'starting') for item in active)

    d.wait('existing deployment service health', services_ready, seconds=180)
    check(services_ready(),
          'All configured deployment services are running')
    check(all(item.get('Health') != 'unhealthy' for item in statuses), 'No service reports an unhealthy Docker state')
    job = json.loads(d.sql("SELECT json_build_object('slug',slug,'state',state,'steps',steps)::text FROM platform_provisioning.jobs WHERE tenant_id='" + tenant + "';", 'platform_security'))
    check(job['state'] == 'Succeeded', 'The original tenant provisioning job remains Succeeded')
    slug = job['slug']
    assert re.fullmatch('[a-z0-9][a-z0-9-]{0,62}', slug)
    store = 'https://' + slug + '.' + d.plan['StoreParentDomain']
    manage = 'https://' + slug + '.' + d.plan['AdminParentDomain']
    portal = 'https://' + d.plan['PortalHost']
    authority = 'https://' + d.plan['IdentityHost'] + '/realms/commerce'
    anonymous = browser(False)
    enrollment.verify_published_frontend(anonymous, portal)
    check(enrollment.api(anonymous, portal, '/api/TrialBusinesses/configuration')[0] in (401, 403), 'Anonymous trial configuration access is denied')
    check(enrollment.api(anonymous, portal, fixture['statusUrl'])[0] in (401, 403), 'Anonymous provisioning status access is denied')
    for path in ('/Admin', '/admin/', '/ADMIN/Product/List'):
        status, headers, body, _ = request(anonymous, store + path)
        check(status == 404 and not headers.get('Location') and b'Admin area access is not allowed' not in body,
              'Storefront admin boundary rejects ' + path)
    status, _, _, _ = request(anonymous, 'https://' + d.plan['IdentityHost'] + '/admin/realms/commerce')
    check(status == 404, 'The Keycloak administration API is not public')
    status, _, _, _ = request(anonymous, authority + '/protocol/openid-connect/token',
                              {'grant_type': 'client_credentials', 'client_id': 'saas-manager', 'client_secret': 'intentionally-invalid-acceptance-secret'})
    check(status == 401, 'Client credentials with an invalid secret are rejected')
    status, _, body, _ = request(anonymous, store + '/')
    check(status == 200 and len(body) > 100, 'Existing tenant storefront responds over trusted HTTPS')

    shopper = browser()
    status, _, body, _ = request(shopper, store + '/login')
    assert status == 200
    page = Page(); page.feed(body.decode())
    form = next(form for form in page.forms if 'Email' in form['fields'] and 'Password' in form['fields'])
    assert form['fields'].get('__RequestVerificationToken')
    target = urllib.parse.urljoin(store, form['action'])
    assert urllib.parse.urlsplit(target).netloc == urllib.parse.urlsplit(store).netloc
    status, _, _, final = request(shopper, target, dict(form['fields'], Email=fixture['email'], Password=fixture['tenantPassword'], RememberMe='false'))
    check(status == 200 and '/login' not in urllib.parse.urlsplit(final).path.lower(), 'The tenant owner password authenticates on the storefront')
    status, _, body, final = request(shopper, store + '/account/info')
    check(status == 200 and urllib.parse.urlsplit(final).path.rstrip('/').lower() == '/account/info' and fixture['email'].encode() in body,
          'The storefront account profile belongs to the authenticated tenant owner')

    owner = browser()
    status, _, body, _ = request(owner, portal + '/api/Auth/login?returnUrl=/register')
    form = LoginForm(); form.feed(body.decode())
    assert status == 200 and form.action and form.action.startswith(authority + '/')
    status, _, body, _ = request(owner, form.action, dict(form.fields, username=fixture['username'], password=fixture['password']))
    callback = enrollment.CallbackForm(portal); callback.feed(body.decode())
    assert status == 200 and callback.action and 'state' in callback.fields
    request(owner, callback.action, callback.fields)
    code, session = enrollment.api(owner, portal, '/api/Auth/sessionInfo')
    check(code == 200 and session['data']['user']['email'] == fixture['email'] and session['data']['registrationStep']['isCompleted'],
          'The original owner authenticates through public HTTPS OIDC and retains completed setup')
    code, configuration = enrollment.api(owner, portal, '/api/TrialBusinesses/configuration')
    check(code == 200 and configuration['business']['databaseReady'] and configuration['business']['id'].replace('-', '') == tenant,
          'SaaS still reconciles the original ready business')
    code, public_job = enrollment.api(owner, portal, fixture['statusUrl'])
    check(code == 200 and public_job['state'] == 'Succeeded' and public_job['steps']['publication']['resources']['readiness'] == 'Verified',
          'The owner status endpoint retains verified publication')
    check('mongodb://' not in json.dumps(public_job) and 'adminPassword' not in json.dumps(public_job),
          'Owner provisioning status contains no database credential or administrator password')

    admin = browser()
    status, _, body, final = request(admin, manage + '/Admin/Product/List')
    assert status == 200 and '/admin/login' in urllib.parse.urlsplit(final).path.lower()
    page = Page(); page.feed(body.decode())
    form = next(form for form in page.forms if 'Email' in form['fields'] and 'Password' in form['fields'])
    assert form['fields'].get('__RequestVerificationToken')
    target = urllib.parse.urljoin(manage, form['action'])
    assert urllib.parse.urlsplit(target).netloc == urllib.parse.urlsplit(manage).netloc
    status, _, _, final = request(admin, target, dict(form['fields'], Email=fixture['email'], Password=fixture['tenantPassword'], RememberMe='false'))
    check(status == 200 and '/admin/login' not in urllib.parse.urlsplit(final).path.lower(), 'The original tenant administrator password still authenticates')
    status, _, body, final = request(admin, manage + '/Admin/Product/List')
    check(status == 200 and urllib.parse.urlsplit(final).path.lower() == '/admin/product/list', 'Authenticated administration opens the actual product list')
    page = Page(); page.feed(body.decode())
    assets = []
    for asset in sorted(set(page.assets)):
        url = urllib.parse.urljoin(manage, asset)
        if urllib.parse.urlsplit(url).netloc != urllib.parse.urlsplit(manage).netloc:
            continue
        status, headers, body, final = request(admin, url)
        suffix = urllib.parse.urlsplit(url).path.lower()
        assert status == 200 and body and urllib.parse.urlsplit(final).path == urllib.parse.urlsplit(url).path
        if suffix.endswith('.css'):
            assert headers.get_content_type() == 'text/css'
        if suffix.endswith('.js'):
            assert headers.get_content_type() in ('application/javascript', 'text/javascript')
        assets.append(suffix)
    check(bool(assets) and any(path.endswith('jquery.min.js') for path in assets), 'All same-origin product-page CSS and JavaScript assets have valid MIME types')

    def rows(page_path, grid_path):
        status, _, body, final = request(admin, manage + page_path)
        assert status == 200 and '/admin/login' not in final.lower()
        page = Page(); page.feed(body.decode()); assert page.token
        status, headers, body, final = request(admin, manage + grid_path, {'Page': 1, 'PageSize': 100, '__RequestVerificationToken': page.token})
        if status != 200 or headers.get_content_type() != 'application/json':
            print('FAIL: administration grid ' + grid_path + ' returned HTTP ' + str(status) + ' (' + headers.get_content_type() + ') at ' + urllib.parse.urlsplit(final).path, flush=True)
        assert status == 200 and headers.get_content_type() == 'application/json'
        value = json.loads(body)
        return value.get('Data', value.get('data', []))

    def field(row, name):
        return row.get(name, row.get(name[:1].lower() + name[1:]))

    currencies = rows('/Admin/Currency/List', '/Admin/Currency/ListGrid')
    check(any(field(row, 'CurrencyCode') == 'TRY' and field(row, 'IsPrimaryStoreCurrency') and field(row, 'IsPrimaryExchangeRateCurrency') for row in currencies),
          'TRY remains both the primary store and exchange currency')
    providers = rows('/Admin/Tax/Providers', '/Admin/Tax/Providers')
    check({'Tax.FixedRate', 'Tax.CountryStateZip'} <= {field(row, 'SystemName') for row in providers}, 'Both tenant tax providers remain available')
    rates = rows('/Admin/TaxFixedRate/Configure', '/Admin/TaxFixedRate/Configure')
    check({1, 10, 20} <= {float(field(row, 'Rate')) for row in rates}, 'Tax categories retain the required 1, 10 and 20 percent fixed rates')
    configured_plugins = set(json.loads((state / 'config/admin.json').read_text())['Extensions']['InstalledPlugins'].split(','))
    database_name = public_job['steps']['database']['resources']['databaseName']
    assert database_name == 'tenant_' + tenant
    # The tenant owner cannot manage platform plugin binaries. Inspect only the installation
    # ledger with the existing deployment operator; never grant extra owner permissions.
    mongo_input = {'password': d.record['Credentials']['mongo'], 'database': database_name}
    script = 'const s=' + json.dumps(mongo_input) + ';\n' + r'''
const admin=db.getSiblingDB('admin'); if(!admin.auth('platform_root',s.password))throw Error('Operator authentication failed');
const tenant=db.getSiblingDB(s.database);
print(JSON.stringify(tenant.getCollection('InstalledPlugin').find({}, {SystemName:1,_id:0}).toArray()));
'''
    plugins = json.loads(d.run('exec', '-T', 'mongo', 'mongosh', '--quiet', '--file', '/dev/stdin', input=script, capture=True).stdout.strip())
    installed_plugins = {row['SystemName'] for row in plugins}
    check(bool(configured_plugins) and configured_plugins <= installed_plugins, 'Every configured administration plugin has a tenant-owned installation record')
    attributes = rows('/Admin/AddressAttribute/List', '/Admin/AddressAttribute/List')
    required = {'lat', 'long', 'bno', 'dno', 'kno', 'adres_tarifi'}
    check(required <= {field(row, 'Name') for row in attributes} and all(field(row, 'IsRequired') for row in attributes if field(row, 'Name') in required),
          'All six mobile address attributes remain required')
    metadata = json.loads(subprocess.check_output(['docker', 'image', 'inspect', d.definition['services']['saas']['image']], text=True))[0]
    revision = metadata['Config']['Labels']['org.opencontainers.image.revision']
    assert re.fullmatch('[0-9a-f]{40}', revision)
    # Only public image references and check names are retained; no tokens, owner or tenant identifiers.
    result = {'version': 1, 'verifiedAtUtc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
              'serverSourceCommit': revision, 'serverImageId': metadata['Id'],
              'serverImage': d.definition['services']['saas']['image'], 'workerImage': d.definition['services']['worker']['image'],
              'configuredServices': sorted(expected), 'completedStepNames': sorted(public_job['steps']),
              'productPageAssetCount': len(assets), 'installedPluginCount': len(installed_plugins), 'requiredTaxRates': [1, 10, 20], 'checks': checks,
              'newTenantCreated': False, 'cloudResourcesCreated': False, 'externalMessagesSentByProbe': False,
              'freshEnrollmentTested': False, 'checkoutOrDeviceDeliveryTested': False}
    save(receipt, result)
    print('Existing tenant acceptance passed; private receipt: ' + str(receipt), flush=True)


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        # HTTP/Playwright exceptions can contain authentication data. Never echo raw exceptions.
        frame = traceback.extract_tb(error.__traceback__)[-1]
        print('FAIL: existing tenant acceptance (' + type(error).__name__ + ', function ' + frame.name + ', line ' + str(frame.lineno) + '); inspect the last completed check.', flush=True)
        raise SystemExit(1) from None
