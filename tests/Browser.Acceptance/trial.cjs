'use strict';
// Standalone real-browser acceptance; no mocked network, direct enrollment POST or saved token traces.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {firefox} = require('playwright');

let stage = 'configuration';
let context;
let page;
let config;
const check = (condition, message) => { assert.ok(condition, message); console.log('PASS: ' + message); };
const canonicalId = value => String(value).replaceAll('-', '').toLowerCase();
const privateJson = (file, value) => {
  fs.writeFileSync(file + '.tmp', JSON.stringify(value, null, 2) + '\n', {mode: 0o600});
  fs.renameSync(file + '.tmp', file);
};

async function launch(profile) {
  return firefox.launchPersistentContext(profile, {
    headless: true, proxy: {server: config.proxy}, ignoreHTTPSErrors: false, acceptDownloads: false,
    firefoxUserPrefs: {'security.enterprise_roots.enabled': false},
  });
}

async function ready(result) {
  await page.getByRole('heading', {name: 'Mağazanız hazır', exact: true}).waitFor({timeout: 180000});
  check(await page.getByRole('link', {name: 'Mağazayı aç', exact: true}).getAttribute('href') === result.storeUrl,
    'The actual Angular success screen links to this tenant storefront');
  check(await page.getByRole('link', {name: 'Mağaza yönetimi', exact: true}).getAttribute('href') === result.adminUrl,
    'The actual Angular success screen links to this tenant administration');
  check(await page.getByRole('alert').count() === 0, 'The completed Angular enrollment has no visible operation error');
}

async function main() {
  process.umask(0o077);
  assert.equal(process.argv.length, 3);
  config = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
  assert.equal(config.portal, 'https://portal.example.test:19443');
  assert.equal(config.identity, 'https://identity.example.test:19443');
  const proxy = new URL(config.proxy);
  assert.equal(proxy.hostname, '172.30.81.1');
  assert.equal(proxy.protocol, 'http:');
  for (const name of ['profile', 'result', 'ca', 'screenshots', 'resume']) assert.ok(path.isAbsolute(config[name]));
  fs.mkdirSync(config.screenshots, {recursive: true, mode: 0o700});

  stage = 'reject untrusted TLS';
  const untrusted = config.profile + '-untrusted';
  assert.ok(!fs.existsSync(untrusted) && !fs.existsSync(config.profile));
  try {
    context = await launch(untrusted);
    page = await context.newPage();
    let rejected = false;
    try { await page.goto(config.portal, {waitUntil: 'domcontentloaded', timeout: 30000}); }
    catch (error) { rejected = /SEC_ERROR_UNKNOWN_ISSUER|MOZILLA_PKIX_ERROR|NS_ERROR_UNKNOWN_ISSUER/.test(error.message); }
    check(rejected, 'A fresh browser rejects the fixture HTTPS chain before its CA is explicitly trusted');
  } finally {
    if (context) { await context.close(); context = undefined; page = undefined; }
    fs.rmSync(untrusted, {recursive: true, force: true});
  }
  stage = 'private browser CA';
  fs.mkdirSync(config.profile, {mode: 0o700});
  execFileSync('certutil', ['-N', '--empty-password', '-d', 'sql:' + config.profile], {stdio: 'pipe'});
  execFileSync('certutil', ['-A', '-d', 'sql:' + config.profile, '-n', 'Commerce fixture CA', '-t', 'C,,', '-i', config.ca], {stdio: 'pipe'});

  stage = 'launch trusted browser';
  context = await launch(config.profile);
  page = await context.newPage();
  page.setDefaultTimeout(30000);
  page.setDefaultNavigationTimeout(30000);
  stage = 'home registration CTA';
  const home = await page.goto(config.portal + '/', {waitUntil: 'domcontentloaded'});
  check(home.ok(), 'The actual compiled SaaS home page loads over validated HTTPS');
  await page.locator('app-trial-section').getByRole('button', {name: 'Hemen Başlayın', exact: true}).waitFor();
  await page.locator('app-hero-section').getByRole('button', {name: '15 Gün Ücretsiz Deneyin', exact: true}).click();
  stage = 'Keycloak browser login';
  await page.waitForURL(url => url.origin === config.identity && url.pathname.includes('/protocol/openid-connect/auth'));
  await page.locator('input[name="username"]').fill(config.account.username);
  await page.locator('input[name="password"]').fill(config.account.password);
  await page.locator('#kc-login').click();
  await page.waitForURL(config.portal + '/register');
  await page.getByRole('heading', {name: 'İşletmenizi oluşturun', exact: true}).waitFor();
  check(true, 'The home CTA reaches real Keycloak login and returns to the Angular business registration form');

  stage = 'Angular dynamic business form';
  for (const [field, value] of Object.entries(config.business)) {
    await page.locator('[id="' + field + '" i]').fill(value);
  }
  await page.locator('#adminPassword').fill(config.adminPassword);
  const submit = page.getByRole('button', {name: 'Deneme aboneliğini başlat', exact: true});
  check(await submit.isEnabled(), 'Actual Angular validators accept the complete synthetic business and chosen administrator password');
  const responsePromise = page.waitForResponse(response => new URL(response.url()).pathname === '/api/TrialBusinesses' && response.request().method() === 'POST');
  await submit.click();
  const response = await responsePromise;
  check(response.status() === 200, 'The visible registration form submits the actual authenticated antiforgery-protected enrollment');
  const request = response.request().postDataJSON();
  const enrollment = await response.json();
  const tenant = canonicalId(enrollment.businessId);
  assert.match(tenant, /^[a-f0-9]{32}$/);
  check(tenant === canonicalId(request.registrationId), 'The browser-generated registration identity matches the persisted tenant');
  assert.match(enrollment.statusUrl, /^\/api\/Provisioning\/[a-f0-9-]{32,36}$/i);

  stage = 'Angular provisioning completion';
  await page.getByRole('heading', {name: 'Mağazanız hazır', exact: true}).waitFor({timeout: 180000});
  const result = {tenantId: tenant, businessId: enrollment.businessId, statusUrl: enrollment.statusUrl,
    storeUrl: await page.getByRole('link', {name: 'Mağazayı aç', exact: true}).getAttribute('href'),
    adminUrl: await page.getByRole('link', {name: 'Mağaza yönetimi', exact: true}).getAttribute('href')};
  for (const [name, parent, pathname] of [['storeUrl', 'shops.example.test', '/'], ['adminUrl', 'manage.example.test', '/Admin']]) {
    const address = new URL(result[name]);
    check(address.protocol === 'https:' && address.port === '19443' && address.hostname.endsWith('.' + parent) &&
      address.pathname === pathname && !address.search && !address.hash && !address.username && !address.password,
      'The browser receives a validated tenant ' + name);
  }
  await ready(result);
  await page.screenshot({path: path.join(config.screenshots, 'tenant-ready.png'), mask: [page.locator('input, textarea')]});
  stage = 'browser reload';
  await page.reload({waitUntil: 'domcontentloaded'});
  await ready(result);
  check(true, 'Refreshing the actual Angular page resumes the same completed tenant without another enrollment');
  privateJson(config.result, result);
  stage = 'wait for Compose restart';
  const deadline = Date.now() + 900000;
  while (!fs.existsSync(config.resume)) {
    assert.ok(Date.now() < deadline, 'The owning fixture must complete its restart');
    await new Promise(resolve => setTimeout(resolve, 500));
  }
  stage = 'browser session after Compose restart';
  await page.reload({waitUntil: 'domcontentloaded'});
  await ready(result);
  check(new URL(page.url()).origin === config.portal, 'The real browser owner session survives the full Compose restart without another login');
  await page.screenshot({path: path.join(config.screenshots, 'after-restart.png'), mask: [page.locator('input, textarea')]});
}

process.once('SIGTERM', async () => {
  if (context) await context.close().catch(() => {});
  process.exit(143);
});

main().catch(async () => {
  // Playwright errors can include passwords passed to fill(); never log raw exceptions, traces or storage state.
  console.error('Real browser acceptance failed at: ' + stage);
  if (page && config) {
    try { await page.screenshot({path: path.join(config.screenshots, 'failure.png'), mask: [page.locator('input, textarea')]}); }
    catch { /* The browser may already be closed. */ }
  }
  process.exitCode = 1;
}).finally(async () => {
  if (context) await context.close().catch(() => {});
});
