#!/usr/bin/env python3
"""Build a real, signed tenant Flutter APK with disposable identities and no cloud publication."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import secrets
import shutil
import subprocess
import sys
import uuid
import xml.etree.ElementTree as ET
from zipfile import ZipFile

import mobile_android as mobile
from test_mobile_android import fixtures


BUILD_NUMBER = 23


def check(condition, description):
    if not condition:
        raise AssertionError(description)
    print('PASS: ' + description, flush=True)


def verify_resources(app, client):
    resources = ET.parse(app / 'build/app/generated/res/processTenantReleaseGoogleServices/values/values.xml').getroot()
    values = {item.attrib.get('name'): item.text for item in resources}
    check(all(values.get(resource) == client[field] for resource, field in [
        ('project_id', 'projectId'), ('gcm_defaultSenderId', 'projectNumber'), ('google_app_id', 'androidAppId')
    ]), 'Release Google Services resources belong to the selected tenant Firebase app.')
    mapping = ET.parse(app / 'build/app/generated/res/injectCrashlyticsMappingFileIdTenantRelease/values/com_google_firebase_crashlytics_mappingfileid.xml').getroot()
    check(any(re.fullmatch(r'[a-f0-9]{32}', item.text or '') for item in mapping.findall('string')),
          'The real Flutter release contains a generated Crashlytics mapping identity.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--flutter', default='flutter')
    parser.add_argument('--android-sdk', default=os.environ.get('ANDROID_HOME') or os.environ.get('ANDROID_SDK_ROOT'))
    parser.add_argument('--prepare-only', action='store_true', help='Exercise source/configuration/signing preparation only; does not claim a release build.')
    args = parser.parse_args()
    sdk = Path(args.android_sdk).absolute() if args.android_sdk else None
    if not args.prepare_only:
        if not sdk:
            parser.error('Supply --android-sdk or ANDROID_HOME.')
        for tool in ['aapt2', 'apksigner']:
            mobile.sdk_tool(sdk, tool)
        if shutil.disk_usage(mobile.ROOT).free < 20 * 1024**3:
            parser.error('This isolated release probe requires at least 20 GiB free, including its own Gradle cache.')
    java_home = os.environ.get('JAVA_HOME')
    keytool = str(Path(java_home) / 'bin' / ('keytool.exe' if os.name == 'nt' else 'keytool')) if java_home else shutil.which('keytool')
    if not keytool:
        parser.error('JDK keytool is required.')
    os.umask(0o077)
    probe = mobile.ROOT / '.local' / ('flutter-release-' + uuid.uuid4().hex[:12])
    probe.mkdir(parents=True, mode=0o700)
    print('Private synthetic release diagnostics: ' + str(probe), flush=True)
    workspace = probe / 'workspace'
    private_paths = [probe / 'fixture.p12', probe / 'signing.properties', probe / 'manifest.json',
                     probe / 'firebase-client.json', probe / 'google-services.json']
    log_path = probe / 'fixture.log'
    try:
        manifest, client, android = fixtures()
        for path, value in zip(private_paths[2:], [manifest, client, android]):
            mobile.private_json(path, value)
        workspace, tenant = mobile.prepare(probe / 'manifest.json', probe, workspace, BUILD_NUMBER)
        check(tenant['sourceHash'] == mobile.source_hash(), 'The isolated release uses the tracked mobile checkout unchanged.')
        password = secrets.token_hex(24)
        environment = dict(os.environ, PLATFORM_SYNTHETIC_SIGNING_PASSWORD=password)
        with log_path.open('w') as log:
            mobile.run_private([keytool, '-genkeypair', '-noprompt', '-storetype', 'PKCS12', '-alias', 'fixture',
                                '-keyalg', 'RSA', '-keysize', '3072', '-validity', '2',
                                '-dname', 'CN=Disposable Flutter Release Fixture', '-keystore', str(private_paths[0]),
                                '-storepass:env', 'PLATFORM_SYNTHETIC_SIGNING_PASSWORD', '-keypass:env', 'PLATFORM_SYNTHETIC_SIGNING_PASSWORD'],
                               probe, environment, log, 120)
            certificate = subprocess.check_output([keytool, '-exportcert', '-alias', 'fixture', '-keystore', str(private_paths[0]),
                                                   '-storepass:env', 'PLATFORM_SYNTHETIC_SIGNING_PASSWORD'],
                                                  env=environment, stderr=log)
        expected_certificate = hashlib.sha256(certificate).hexdigest()
        private_paths[0].chmod(0o600)
        # Java properties require escaping backslashes and drive-colon paths on Windows.
        store_path = str(private_paths[0]).replace('\\', '\\\\').replace(':', '\\:')
        private_paths[1].write_text('storeFile=' + store_path + '\nstorePassword=' + password + '\nkeyAlias=fixture\nkeyPassword=' + password + '\n')
        private_paths[1].chmod(0o600)
        check(len(certificate) > 500 and private_paths[0].is_file(), 'An ephemeral RSA-3072 signing identity was created without a repository secret.')
        if args.prepare_only:
            mobile.private_json(probe / 'result.json', {'sourceHash': tenant['sourceHash'], 'preparationVerified': True,
                                                       'flutterReleaseBuilt': False, 'cloudPublished': False})
            print('Preparation passed; no Flutter release was built.', flush=True)
            return 0
        gradle = probe / 'gradle'
        (gradle / 'init.d').mkdir(parents=True, mode=0o700)
        (gradle / 'gradle.properties').write_text('org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G -XX:ReservedCodeCacheSize=256m\norg.gradle.workers.max=2\norg.gradle.parallel=false\nkotlin.compiler.execution.strategy=in-process\n')
        # The synthetic project has no remote resources. Disable only outbound Crashlytics
        # upload tasks in this probe's own Gradle home; retain native resource generation.
        (gradle / 'init.d' / 'synthetic-release.gradle').write_text('''allprojects {
    tasks.configureEach {
        if (name.startsWith("uploadCrashlytics")) {
            enabled = false
        }
    }
}
gradle.taskGraph.whenReady { graph ->
    def uploads = graph.allTasks.findAll { it.name.startsWith("uploadCrashlytics") }
    if (uploads.any { it.enabled }) {
        throw new GradleException("Synthetic release cannot enable cloud uploads")
    }
    def audit = new File(System.getenv("PLATFORM_SYNTHETIC_GRADLE_AUDIT"))
    audit.text = groovy.json.JsonOutput.toJson([
        tasks: graph.allTasks.collect { it.path },
        uploads: uploads.collect { [path: it.path, enabled: it.enabled] }
    ])
}
''')
        audit_path = probe / 'gradle-task-audit.json'
        prior_gradle_home = os.environ.get('GRADLE_USER_HOME')
        prior_audit_path = os.environ.get('PLATFORM_SYNTHETIC_GRADLE_AUDIT')
        try:
            os.environ['GRADLE_USER_HOME'] = str(gradle)
            os.environ['PLATFORM_SYNTHETIC_GRADLE_AUDIT'] = str(audit_path)
            with log_path.open('a') as log:
                binary, result = mobile.build(workspace, tenant, private_paths[1], args.flutter, sdk, BUILD_NUMBER, log)
        finally:
            if prior_gradle_home is None:
                os.environ.pop('GRADLE_USER_HOME', None)
            else:
                os.environ['GRADLE_USER_HOME'] = prior_gradle_home
            if prior_audit_path is None:
                os.environ.pop('PLATFORM_SYNTHETIC_GRADLE_AUDIT', None)
            else:
                os.environ['PLATFORM_SYNTHETIC_GRADLE_AUDIT'] = prior_audit_path
        check(result['signingCertificateSha256'] == expected_certificate,
              'The full Flutter release APK is signed by this fixture signing identity.')
        check(result['sha256'] == mobile.file_hash(binary) and result['buildNumber'] == BUILD_NUMBER,
              'The release APK hash, package, non-debuggable flag and build number are verified.')
        verify_resources(workspace / 'Platforms/store_user_app', client)
        with ZipFile(binary) as apk:
            names = set(apk.namelist())
            check('lib/arm64-v8a/libapp.so' in names and 'lib/arm64-v8a/libflutter.so' in names,
                  'The artifact contains the compiled ARM64 Flutter application and engine.')
        audit = mobile.read_json(audit_path)
        check(':app:assembleTenantRelease' in audit.get('tasks', []) and
              ':app:processTenantReleaseGoogleServices' in audit['tasks'] and
              all(item.get('enabled') is False for item in audit.get('uploads', [])),
              'The actual release task graph retained Firebase resource work and disabled cloud upload tasks.')
        mobile.private_json(probe / 'result.json', dict(result, flutterReleaseBuilt=True, cloudPublished=False,
                                                       crashDeliveryVerified=False, apkBytes=binary.stat().st_size))
        print('Real tenant Flutter release checks passed; no cloud release, crash report or device delivery was performed.', flush=True)
        return 0
    except Exception as error:
        print('Synthetic Flutter release probe failed (' + type(error).__name__ + '). Inspect the private fixture.log.', file=sys.stderr)
        return 1
    finally:
        # Never retain/distribute a runnable APK with this disposable signing identity.
        for path in private_paths:
            path.unlink(missing_ok=True)
        if workspace.exists():
            shutil.rmtree(workspace)
        if (probe / 'gradle').exists():
            shutil.rmtree(probe / 'gradle')


if __name__ == '__main__':
    raise SystemExit(main())
