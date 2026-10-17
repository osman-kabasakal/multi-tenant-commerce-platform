#!/usr/bin/env python3
"""Prepare, sign and optionally distribute an owned tenant Android app in an isolated workspace."""
import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import signal
import shutil
import subprocess
import sys
import uuid
import xml.etree.ElementTree as ET
from urllib.parse import urlsplit

ROOT = Path(__file__).resolve().parents[1]
MAX_CONFIG_BYTES = 2 * 1024 * 1024
BUILD_TOOLS_VERSION = '35.0.0'


def read_json(path):
    path = Path(path)
    if path.is_symlink() or not path.is_file() or path.stat().st_size > MAX_CONFIG_BYTES:
        raise ValueError('Use a bounded regular configuration file.')
    value = json.loads(path.read_text())
    if not isinstance(value, dict):
        raise ValueError('Configuration must be a JSON object.')
    return value


def private_json(path, value):
    path = Path(path)
    descriptor = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    with os.fdopen(descriptor, 'w') as output:
        json.dump(value, output, indent=2, ensure_ascii=False)
        output.write('\n')


def validate(manifest, client, android):
    tenant = manifest.get('tenantId', '')
    slug = manifest.get('slug', '')
    if not re.fullmatch(r'[a-f0-9]{32}', tenant) or int(tenant, 16) == 0 or client.get('tenantId') != tenant:
        raise ValueError('Firebase export and manifest require the same canonical business id.')
    if not re.fullmatch(r'[a-z][a-z0-9-]{1,38}[a-z0-9]', slug) or manifest.get('localDemo') is not False:
        raise ValueError('Use a published non-demo tenant manifest.')
    uri = urlsplit(manifest.get('baseUrl', ''))
    if uri.scheme != 'https' or not uri.hostname or uri.username or uri.password or uri.path not in ('', '/') or uri.query or uri.fragment:
        raise ValueError('Use the published HTTPS storefront origin.')
    if uri.port is not None and not 1 <= uri.port <= 65535:
        raise ValueError('Invalid storefront HTTPS port.')
    domain = manifest.get('verifiedDomain')
    if domain is not None:
        fields = {'id', 'ownerSubject', 'storeHost', 'adminHost', 'zoneId', 'zoneName'}
        if not isinstance(domain, dict) or set(domain) != fields or any(not isinstance(domain[k], str) for k in fields):
            raise ValueError('Use the complete verified custom domain snapshot.')
        import uuid
        for field in ('id', 'ownerSubject'):
            parsed = uuid.UUID(domain[field])
            if parsed.int == 0 or str(parsed) != domain[field]:
                raise ValueError('Use canonical verified domain references.')
        host, zone = domain['storeHost'], domain['zoneName']
        def public_host(value):
            return len(value) <= 190 and len(value.split('.')) >= 2 and all(re.fullmatch(r'[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?', label) for label in value.split('.'))
        if not public_host(host) or not public_host(zone) or not re.fullmatch(r'[a-f0-9]{32}', domain['zoneId']) or domain['adminHost'] != 'manage.' + host or uri.hostname != host or not (host == zone or host.endswith('.' + zone)):
            raise ValueError('The storefront origin differs from its verified custom domain snapshot.')
    elif uri.hostname.split('.')[0] != slug:
        raise ValueError('The storefront host must belong to the published slug or a verified custom domain.')
    identity = manifest.get('mobileIdentityId', '')
    if not isinstance(identity, str) or identity and (not re.fullmatch(r'[a-f0-9]{32}', identity) or int(identity, 16) == 0):
        raise ValueError('Use a canonical mobile identity version.')
    cloud = manifest.get('firebase', {})
    if cloud.get('enabled') is not True:
        raise ValueError('Google/Firebase provisioning must have completed explicitly.')
    for key in ('projectId', 'projectNumber', 'androidAppId', 'iosAppId'):
        if not client.get(key) or client[key] != cloud.get(key):
            raise ValueError('Firebase export belongs to another published tenant app.')
    transport = client.get('iosPushTransport', 'Fcm')
    team = client.get('iosDevelopmentTeam')
    if transport not in ('Fcm', 'Apns') or transport == 'Apns' and (not isinstance(team, str) or not re.fullmatch(r'[A-Z0-9]{10}', team)):
        raise ValueError('Select a valid iOS push transport and Apple team for APNs.')
    project, number = client['projectId'], client['projectNumber']
    if not re.fullmatch(r'[a-z][a-z0-9-]{4,28}[a-z0-9]', project) or not re.fullmatch(r'[1-9][0-9]*', number):
        raise ValueError('Invalid Firebase project identity.')
    for key, field, platform in [('androidApplicationId', 'androidPackageName', 'android'), ('iosBundleId', 'iosBundleId', 'ios')]:
        package = manifest.get(key, '')
        pattern = r'[A-Za-z][A-Za-z0-9-]*(\.[A-Za-z][A-Za-z0-9-]*)+' if platform == 'ios' else r'[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+'
        if package != client.get(field) or not re.fullmatch(pattern, package):
            raise ValueError('The native package does not match its Firebase export.')
        if not re.fullmatch('1:' + re.escape(number) + ':' + platform + r':[A-Za-z0-9]+', client[platform + 'AppId']):
            raise ValueError('The Firebase app does not match its project and platform.')
    info = android.get('project_info', {})
    clients = android.get('client', [])
    matches = [c for c in clients if c.get('client_info', {}).get('android_client_info', {}).get('package_name') == client['androidPackageName']]
    if info.get('project_id') != project or str(info.get('project_number')) != number or len(matches) != 1:
        raise ValueError('Android SDK configuration belongs to another project or package.')
    if matches[0]['client_info'].get('mobilesdk_app_id') != client['androidAppId']:
        raise ValueError('Android SDK configuration belongs to another Firebase app.')
    if not isinstance(manifest.get('displayName'), str) or not 1 <= len(manifest['displayName']) <= 200 or any(ord(c) < 32 for c in manifest['displayName']):
        raise ValueError('Use a bounded display name without control characters.')
    return {
        'tenantId': tenant, 'slug': slug, 'androidApplicationId': client['androidPackageName'],
        'displayName': manifest['displayName'], 'deepLinkHost': uri.hostname,
        'projectId': project, 'projectNumber': number, 'androidAppId': client['androidAppId'],
        'iosAppId': client['iosAppId'], 'storeUrl': manifest['baseUrl'].rstrip('/'),
        'iosPushTransport': transport, 'iosDevelopmentTeam': team, 'mobileIdentityId': identity,
    }


def validate_source_name(name):
    if not isinstance(name, str):
        raise ValueError('Invalid mobile source path.')
    parts = PurePosixPath(name).parts
    blocked = ('.', '..', '.git', '.local', 'node_modules', 'build', 'bin', 'obj', '.dart_tool', '.gradle', 'Pods')
    if not parts or str(PurePosixPath(name)) != name or PurePosixPath(name).is_absolute() or '\\' in name or any(part in blocked for part in parts) or any(ord(c) < 32 for c in name):
        raise ValueError('Invalid mobile source path.')
    if not (name.startswith('Platforms/store_user_app/') or name.startswith('Platforms/modules/') or name == 'scripts/mobile_android.py'):
        raise ValueError('The source package contains a file outside the mobile checkout.')
    base = PurePosixPath(name).name
    if base in ('google-services.json', 'GoogleService-Info.plist', 'firebase_options.dart', 'key.properties', 'local.properties') or Path(name).suffix.lower() in ('.p12', '.pfx', '.key', '.pem', '.jks', '.keystore') or re.fullmatch(r'service[-_]?account.*\.json', base, re.IGNORECASE) or (base.startswith('.env') and base != '.env.example'):
        raise ValueError('Private credentials and generated SDK/signing files cannot enter a source package.')


def source_files(root=ROOT):
    packaged = root / 'mobile-source.json'
    expected = {}
    if packaged.exists():
        manifest = read_json(packaged)
        if manifest.get('version') != 1 or not isinstance(manifest.get('files'), list) or not 1 <= len(manifest['files']) <= 20000:
            raise ValueError('Invalid immutable mobile source package.')
        for item in manifest['files']:
            name, digest = item.get('path', ''), item.get('sha256', '')
            if not isinstance(name, str) or not isinstance(digest, str) or not re.fullmatch(r'[a-f0-9]{64}', digest):
                raise ValueError('Invalid packaged source digest.')
            validate_source_name(name)
            if name in expected:
                raise ValueError('Duplicate packaged mobile source path.')
            expected[name] = digest
        names = list(expected)
    else:
        names = subprocess.check_output(['git', 'ls-files', '--cached', '-z', '--', 'Platforms/store_user_app', 'Platforms/modules', 'scripts/mobile_android.py'], cwd=root).decode().split('\0')
    for name in sorted(set(filter(None, names))):
        validate_source_name(name)
        path = root / name
        if path.is_symlink():
            raise ValueError('Mobile build sources cannot be symbolic links.')
        if not path.is_file():
            raise ValueError('A tracked or packaged source file is missing.')
        if name in expected and file_hash(path) != expected[name]:
            raise ValueError('A packaged mobile source file changed.')
        yield path, name


def file_hash(path):
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    return digest.hexdigest()


def package_source(output, root=ROOT):
    output = Path(output).absolute()
    if output.exists() or output == root or output in root.parents:
        raise ValueError('Use a new isolated mobile source package directory.')
    for parent in [output, *output.parents]:
        if parent.is_symlink():
            raise ValueError('Source package paths cannot contain symbolic links.')
    if root in output.parents and root / '.local' not in output.parents:
        raise ValueError('In-repository source packages must stay under ignored .local.')
    entries = list(source_files(root))
    output.mkdir(parents=True, mode=0o700)
    files = []
    for source, name in entries:
        target = output / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
        files.append({'path': name, 'sha256': file_hash(target)})
    private_json(output / 'mobile-source.json', {'version': 1, 'files': files})
    return output


def hash_sources(entries):
    digest = hashlib.sha256()
    for path, name in sorted(entries, key=lambda item: item[1]):
        file_digest = hashlib.sha256()
        with path.open('rb') as stream:
            for block in iter(lambda: stream.read(1024 * 1024), b''):
                file_digest.update(block)
        digest.update(name.encode('utf-8') + b'\0' + file_digest.digest())
    return digest.hexdigest()


def source_hash(root=ROOT):
    return hash_sources(list(source_files(root)))



def branding_digest(value):
    if not isinstance(value, dict) or set(value) != {'android', 'ios'}:
        raise ValueError('Use the frozen Android and iOS branding snapshot.')
    parts = ['branding-v1']
    for platform in ('android', 'ios'):
        images = value[platform]
        if not isinstance(images, dict) or set(images) != {'logo', 'icon', 'splash'}:
            raise ValueError('Invalid tenant branding slots.')
        for role in ('logo', 'icon', 'splash'):
            digest = images[role]
            if not isinstance(digest, str) or not re.fullmatch('[a-f0-9]{64}', digest):
                raise ValueError('Invalid tenant branding content digest.')
            parts.append(digest)
    return hashlib.sha256(('\n'.join(parts) + '\n').encode()).hexdigest()


def branding_image(path, expected):
    path = Path(path)
    if path.is_symlink() or not path.is_file() or not 24 <= path.stat().st_size <= 5 * 1024**2:
        raise ValueError('Use a bounded regular frozen branding image.')
    if file_hash(path) != expected:
        raise ValueError('Tenant branding bytes differ from the selected release.')
    with path.open('rb') as stream:
        header = stream.read(24)
    if header.startswith(b'\x89PNG\r\n\x1a\n') and header[8:16] == b'\x00\x00\x00\x0dIHDR':
        if not all(1 <= int.from_bytes(header[offset:offset+4], 'big') <= 4096 for offset in (16, 20)):
            raise ValueError('Branding image dimensions exceed the supported range.')
        return 'png'
    if header.startswith(b'\xff\xd8\xff'):
        # The shared store checks JPEG dimensions; the pinned generator decodes it before compilation.
        return 'jpg'
    raise ValueError('Use PNG or JPEG branding bytes.')


def prepare_branding(manifest, inputs, app, platform):
    value = manifest.get('branding')
    if value is None:
        return {}
    digest = branding_digest(value)
    if platform not in ('android', 'ios'):
        raise ValueError('Choose one native branding platform.')
    directory = app / 'assets/tenant_branding'
    directory.mkdir(mode=0o700)
    paths = {}
    for role, expected in value[platform].items():
        source = inputs / 'branding' / (expected + '.image')
        extension = branding_image(source, expected)
        target = directory / (role + '.' + extension)
        shutil.copyfile(source, target)
        target.chmod(0o600)
        paths[role] = target.relative_to(app).as_posix()
    pubspec = app / 'pubspec.yaml'
    text = pubspec.read_text()
    if text.count('    - assets/\n') != 1:
        raise ValueError('Expected one tracked root assets declaration.')
    pubspec.write_text(text.replace('    - assets/\n', '    - assets/\n    - assets/tenant_branding/\n', 1))
    private_json(app / 'platform_launcher_icons.yaml', {'flutter_launcher_icons': {
        'android': platform == 'android', 'ios': platform == 'ios', 'image_path': paths['icon'],
        'remove_alpha_ios': True, 'background_color_ios': '#FFFFFF',
        'adaptive_icon_background': '#FFFFFF', 'adaptive_icon_foreground': paths['icon'],
    }})
    private_json(app / 'platform_native_splash.yaml', {'flutter_native_splash': {
        'android': platform == 'android', 'ios': platform == 'ios', 'web': False,
        'color': '#FFFFFF', 'image': paths['splash'], 'color_dark': '#FFFFFF', 'image_dark': paths['splash'],
        'android_12': {'color': '#FFFFFF', 'image': paths['icon'], 'color_dark': '#FFFFFF', 'image_dark': paths['icon']},
    }})
    return {'branding': value, 'brandingSha256': digest, 'brandingPlatform': platform, 'storeLogo': paths['logo']}


def branding_commands(flutter, tenant):
    if not tenant.get('branding'):
        return []
    branding_digest(tenant['branding'])
    return [[flutter, 'pub', 'run', 'flutter_launcher_icons', '-f', 'platform_launcher_icons.yaml'],
            [flutter, 'pub', 'run', 'flutter_native_splash:create', '--path=platform_native_splash.yaml']]


def verify_branding_assets(binary, tenant):
    if not tenant.get('branding'):
        return
    import zipfile
    branding_digest(tenant['branding'])
    with zipfile.ZipFile(binary) as archive:
        for role, expected in tenant['branding']['android'].items():
            names = [name for name in archive.namelist() if name in [
                'assets/flutter_assets/assets/tenant_branding/' + role + '.' + extension for extension in ('png', 'jpg')]]
            if len(names) != 1 or archive.getinfo(names[0]).file_size > 5 * 1024**2 or hashlib.sha256(archive.read(names[0])).hexdigest() != expected:
                raise ValueError('The compiled APK lost its selected tenant branding image.')


def prepare(manifest_path, firebase_directory, workspace, build_number, root=ROOT, branding_platform="android"):
    manifest = read_json(manifest_path)
    client = read_json(Path(firebase_directory) / 'firebase-client.json')
    android = read_json(Path(firebase_directory) / 'google-services.json')
    tenant = validate(manifest, client, android)
    if not 1 <= build_number <= 2100000000:
        raise ValueError('Use a positive Android version code within the supported range.')
    workspace = Path(workspace).absolute()
    if workspace == root or workspace in root.parents or workspace.exists():
        raise ValueError('Use a new isolated build workspace; existing files are never overwritten.')
    if root in workspace.parents and root / '.local' not in workspace.parents:
        raise ValueError('In-repository build workspaces must be under ignored .local.')
    for parent in [workspace, *workspace.parents]:
        if parent.is_symlink():
            raise ValueError('Build workspaces cannot contain symbolic links.')
    workspace.mkdir(parents=True, mode=0o700)
    entries = list(source_files(root))
    for path, name in entries:
        target = workspace / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, target)
    tenant['sourceHash'] = hash_sources([(workspace / name, name) for _, name in entries])
    app = workspace / 'Platforms/store_user_app'
    if not (app / 'pubspec.lock').is_file() or not (app / 'lib/core/config/tenant_firebase_identity.dart').is_file():
        raise ValueError('A complete compatible mobile checkout is required.')
    sdk_path = app / 'android/app/src/tenant/google-services.json'
    sdk_path.parent.mkdir(parents=True, exist_ok=True)
    private_json(sdk_path, android)
    resources = ET.Element('resources')
    label = ET.SubElement(resources, 'string', {'name': 'app_name'})
    label.text = '"' + tenant['displayName'].replace('\\', '\\\\').replace('"', '\\"') + '"'
    strings = app / 'android/app/src/tenant/res/values/strings.xml'
    strings.parent.mkdir(parents=True, exist_ok=True)
    strings.write_bytes(ET.tostring(resources, encoding='utf-8', xml_declaration=True))
    tenant.update(prepare_branding(manifest, Path(manifest_path).parent, app, branding_platform))
    # Paths embedded in manifests are never read or used as executable commands.
    private_json(workspace / 'tenant-build.json', dict(tenant, buildNumber=build_number))
    private_json(workspace / 'tenant.defines.json', {
        'LOCAL_DEMO': 'false', 'TENANT_ID': tenant['tenantId'], 'STORE_URL': tenant['storeUrl'],
        'APP_TITLE': tenant['displayName'], 'STORE_LOGO': tenant.get('storeLogo', ''), 'PACKAGE_NAME_ANDROID': tenant['androidApplicationId'],
        'PACKAGE_NAME_IOS': client['iosBundleId'], 'FIREBASE_PROJECT_ID': tenant['projectId'],
        'FIREBASE_PROJECT_NUMBER': tenant['projectNumber'], 'FIREBASE_ANDROID_APP_ID': tenant['androidAppId'],
        'FIREBASE_IOS_APP_ID': tenant['iosAppId'],
        'MOBILE_IDENTITY_ID': tenant.get('mobileIdentityId', ''), 'IOS_PUSH_TRANSPORT': tenant['iosPushTransport'], 'IOS_DEVELOPMENT_TEAM': tenant['iosDevelopmentTeam'] or '',
    })
    return workspace, tenant


def sdk_tool(sdk, tool):
    if tool not in ('aapt2', 'apksigner'):
        raise ValueError('Choose a supported Android verification tool.')
    suffix = ('.bat' if tool == 'apksigner' else '.exe') if os.name == 'nt' else ''
    candidate = Path(sdk) / 'build-tools' / BUILD_TOOLS_VERSION / (tool + suffix)
    if not candidate.is_file():
        raise ValueError('Install the pinned Android SDK build-tools ' + BUILD_TOOLS_VERSION + ' with aapt2 and apksigner.')
    return candidate


def run_private(command, cwd, environment, log, timeout):
    process = subprocess.Popen(command, cwd=cwd, env=environment, stdout=log, stderr=subprocess.STDOUT, start_new_session=(os.name != 'nt'))
    try:
        code = process.wait(timeout=timeout)
        if code:
            raise subprocess.CalledProcessError(code, command)
    except BaseException:
        if process.poll() is None:
            if os.name == 'nt':
                process.kill()
            else:
                os.killpg(process.pid, signal.SIGKILL)
            process.wait()
        raise


def build(workspace, tenant, signing, flutter, sdk, build_number, log):
    signing = Path(signing).absolute()
    if signing.is_symlink() or not signing.is_file():
        raise ValueError('Supply a regular private Android signing-properties file.')
    if os.name != 'nt' and signing.stat().st_mode & 0o077:
        raise ValueError('Android signing properties must be accessible only to their owner.')
    if shutil.disk_usage(workspace).free < 15 * 1024**3:
        raise ValueError('A signed Android build requires at least 15 GiB free disk space.')
    environment = dict(os.environ, PLATFORM_TENANT_CONFIG=str(workspace / 'tenant-build.json'), PLATFORM_ANDROID_SIGNING_PROPERTIES=str(signing), ANDROID_HOME=str(sdk), GRADLE_OPTS=os.environ.get('GRADLE_OPTS', '') + ' -Dorg.gradle.daemon=false')
    app = workspace / 'Platforms/store_user_app'
    lockfile = app / 'pubspec.lock'
    locked_dependencies = file_hash(lockfile)
    commands = [
        [flutter, 'pub', 'get', '--enforce-lockfile'],
        *branding_commands(flutter, tenant),
        [flutter, 'build', 'apk', '--release', '--flavor', 'tenant', '--target-platform', 'android-arm64', '--build-number', str(build_number), '--dart-define-from-file=' + str(workspace / 'tenant.defines.json')],
    ]
    for command in commands:
        # Flutter must regenerate release-mode plugin registration. --no-pub skips
        # that phase and retains development-only native plugins from pub get.
        run_private(command, app, environment, log, 3600)
        if lockfile.is_symlink() or not lockfile.is_file() or file_hash(lockfile) != locked_dependencies:
            raise ValueError('The release build changed its locked dependencies.')
    binary = app / 'build/app/outputs/flutter-apk/app-tenant-release.apk'
    result = verify_binary(binary, tenant, sdk, build_number, environment)
    result['crashlytics'] = 'Native plugin and Dart handlers configured; live delivery unverified'
    return binary, result


def verify_binary(binary, tenant, sdk, build_number, environment=None):
    binary = Path(binary)
    if binary.is_symlink() or not binary.is_file():
        raise ValueError('Flutter did not produce a regular tenant release APK.')
    signature = subprocess.run([str(sdk_tool(sdk, 'apksigner')), 'verify', '--verbose', '--print-certs', str(binary)], capture_output=True, text=True, check=True, env=environment)
    badging = subprocess.check_output([str(sdk_tool(sdk, 'aapt2')), 'dump', 'badging', str(binary)], text=True, env=environment)
    match = re.search(r"^package: name='([^']+)' versionCode='([^']+)'", badging, re.MULTILINE)
    fingerprint = re.search(r'^Signer #1 certificate SHA-256 digest: ([a-fA-F0-9]{64})$', signature.stdout, re.MULTILINE)
    if not match or match.group(1) != tenant['androidApplicationId'] or match.group(2) != str(build_number) or not fingerprint or re.search(r'^application-debuggable(?:\s|$)', badging, re.MULTILINE):
        raise ValueError('The signed APK package, version or certificate was not verified.')
    with binary.open('rb') as stream:
        digest = hashlib.sha256()
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    verify_branding_assets(binary, tenant)
    return dict(tenant, buildNumber=build_number, sha256=digest.hexdigest(), signingCertificateSha256=fingerprint.group(1).lower(), distributed=False)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('manifest', type=Path, nargs='?')
    parser.add_argument('--firebase-directory', type=Path)
    parser.add_argument('--workspace', type=Path)
    parser.add_argument('--build-number', type=int, default=1)
    parser.add_argument('--build', action='store_true', help='Build and verify a signed release; default only prepares an isolated workspace.')
    parser.add_argument('--signing-properties', type=Path)
    parser.add_argument('--flutter', default='flutter')
    parser.add_argument('--android-sdk', default=os.environ.get('ANDROID_HOME') or os.environ.get('ANDROID_SDK_ROOT'))
    parser.add_argument('--distribute-config', type=Path, help='Explicit private Platform.Cloud configuration; requires --build and AllowCloudWrites.')
    parser.add_argument('--source-hash', action='store_true', help='Print the SHA-256 of tracked mobile sources without preparing a workspace.')
    parser.add_argument('--package-source', type=Path, help='Export verified public mobile sources without Git metadata or credentials.')
    parser.add_argument('--verify-apk', type=Path, help='Verify an existing immutable APK without rebuilding or distributing it.')
    parser.add_argument('--expected-build', type=Path, help='Private public-metadata expectation for --verify-apk.')
    args = parser.parse_args()
    special = args.source_hash or args.verify_apk is not None or args.package_source is not None
    if special and (args.manifest or args.firebase_directory or args.build or args.distribute_config or args.workspace):
        parser.error('Source inspection and APK verification cannot prepare, build or distribute a workspace.')
    if args.package_source and (args.source_hash or args.verify_apk or args.expected_build):
        parser.error('Choose source packaging, source inspection or existing APK verification.')
    if args.source_hash and (args.verify_apk or args.expected_build):
        parser.error('Choose source inspection or existing APK verification.')
    if args.verify_apk and (not args.expected_build or not args.android_sdk):
        parser.error('--verify-apk requires --expected-build and --android-sdk.')
    if not special and (not args.manifest or not args.firebase_directory):
        parser.error('Preparation requires a published manifest and --firebase-directory.')
    if args.build and (not args.signing_properties or not args.android_sdk):
        parser.error('--build requires --signing-properties and --android-sdk (or ANDROID_HOME).')
    if args.distribute_config and not args.build:
        parser.error('--distribute-config requires an actual signed --build.')
    os.umask(0o077)
    try:
        if args.package_source:
            print(package_source(args.package_source))
            return 0
        if args.source_hash:
            print(source_hash())
            return 0
        if args.verify_apk:
            print(json.dumps(verify_binary(args.verify_apk, read_json(args.expected_build), args.android_sdk, args.build_number)))
            return 0
        workspace = args.workspace or ROOT / '.local/mobile-builds' / uuid.uuid4().hex
        workspace, tenant = prepare(args.manifest, args.firebase_directory, workspace, args.build_number)
        if args.build:
            with (workspace / 'build.log').open('w') as log:
                binary, result = build(workspace, tenant, args.signing_properties, args.flutter, args.android_sdk, args.build_number, log)
                result['artifact'] = str(binary.relative_to(workspace))
                if args.distribute_config:
                    run_private(['dotnet', 'run', '--project', str(ROOT / 'tools/Platform.Cloud'), '-c', 'Release', '--', 'distribute', '--config', str(args.distribute_config.absolute()), '--tenant', tenant['tenantId'], '--platform', 'android', '--binary', str(binary)], ROOT, os.environ.copy(), log, 1800)
                    result['distributed'] = True
            private_json(workspace / 'build-result.json', result)
        print(workspace)
        return 0
    except Exception as error:
        print('Tenant Android operation failed (' + type(error).__name__ + '). Inspect the private workspace/build log and configuration.', file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
