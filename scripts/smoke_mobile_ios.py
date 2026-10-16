"""Verify real tenant Xcode targets with synthetic Firebase configuration and no cloud writes."""
import argparse
import json
import os
from pathlib import Path
import plistlib
import shutil
import subprocess
import uuid

import mobile_android as common
import mobile_ios

ROOT = Path(__file__).resolve().parents[1]


def fixture_inputs(directory):
    directory.mkdir(mode=0o700)
    tenant = "11111111111111111111111111111111"
    bundle = "dev.commerce.iosfixture"
    cloud = {"enabled": True, "projectId": "ios-fixture-demo", "projectNumber": "123456789",
             "androidAppId": "1:123456789:android:aaaaaaaa", "iosAppId": "1:123456789:ios:bbbbbbbb"}
    manifest = {"tenantId": tenant, "slug": "ios-coffee", "localDemo": False,
                "baseUrl": "https://ios-coffee.shops.example.test", "displayName": 'İşletme "Kahve" & Çay',
                "androidApplicationId": bundle, "iosBundleId": bundle, "firebase": cloud}
    client = dict(cloud, tenantId=tenant, androidPackageName=bundle, iosBundleId=bundle)
    android = {"project_info": {"project_id": cloud["projectId"], "project_number": cloud["projectNumber"]},
               "client": [{"client_info": {"mobilesdk_app_id": cloud["androidAppId"], "android_client_info": {"package_name": bundle}}}]}
    ios = {"PROJECT_ID": cloud["projectId"], "GCM_SENDER_ID": cloud["projectNumber"],
           "GOOGLE_APP_ID": cloud["iosAppId"], "BUNDLE_ID": bundle, "API_KEY": "synthetic-unused-public-ios-key",
           "PLIST_VERSION": "1", "IS_GCM_ENABLED": True}
    for name, value in [("tenant.json", manifest), ("firebase-client.json", client), ("google-services.json", android)]:
        common.private_json(directory / name, value)
    (directory / "GoogleService-Info.plist").write_bytes(plistlib.dumps(ios))
    (directory / "GoogleService-Info.plist").chmod(0o600)
    return directory / "tenant.json"


def verify_project(workspace, tenant, ruby):
    script = r"""
require 'json'
require 'yaml'
gem 'xcodeproj', '1.27.0'
require 'xcodeproj'
ios = File.join(ARGV[0], 'Platforms/store_user_app/ios')
project = Xcodeproj::Project.open(File.join(ios, 'Runner.xcodeproj'))
runner = project.targets.find { |target| target.name == 'Runner' }
extension = project.targets.find { |target| target.name == 'NotificationServiceExtension' }
abort 'Missing native targets.' unless runner && extension
scheme = Xcodeproj::XCScheme.new(File.join(ios, 'Runner.xcodeproj/xcshareddata/xcschemes/tenant.xcscheme'))
copy = runner.copy_files_build_phases.find { |phase| phase.files_references.include?(extension.product_reference) }
thin = runner.shell_script_build_phases.find { |phase| phase.name == 'Thin Binary' }
puts({extensionBeforeFlutterEmbedding: copy && thin && runner.build_phases.index(copy) < runner.build_phases.index(thin), swiftPackageManagerEnabled: YAML.safe_load(File.read(File.join(ios, '../pubspec.yaml'))).fetch('flutter').fetch('config').fetch('enable-swift-package-manager'), configs: project.build_configurations.map(&:name), runner: runner.build_configurations.select { |config| config.name.end_with?('-tenant') }.map { |config| {name: config.name, bundle: config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'], product: config.build_settings['PRODUCT_NAME'], team: config.build_settings['DEVELOPMENT_TEAM'], base: config.base_configuration_reference.real_path.to_s} }, extension: extension.build_configurations.select { |config| config.name.end_with?('-tenant') }.map { |config| {name: config.name, bundle: config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'], product: config.build_settings['PRODUCT_NAME'], team: config.build_settings['DEVELOPMENT_TEAM'], plist: config.build_settings['INFOPLIST_FILE']} }, linked: runner.dependencies.any? { |dependency| dependency.target == extension }, embedded: runner.copy_files_build_phases.select { |phase| phase.dst_subfolder_spec == '13' }.flat_map(&:files_references).any? { |file| file == extension.product_reference }, sdkResources: runner.resources_build_phase.files_references.select { |file| file.path.to_s.end_with?('GoogleService-Info.plist') }.map { |file| file.real_path.to_s }, extensionSources: extension.source_build_phase.files_references.map { |file| file.real_path.to_s }, archiveConfiguration: scheme.archive_action.build_configuration, launchConfiguration: scheme.launch_action.build_configuration }.to_json)
"""
    value = json.loads(subprocess.check_output([ruby, "-e", script, str(workspace)], text=True, timeout=30))
    expected = {mode + "-tenant" for mode in ["Debug", "Profile", "Release"]}
    if value["extensionBeforeFlutterEmbedding"] is not True:
        raise ValueError("Embedding the extension after Flutter embedding creates an Xcode dependency cycle.")
    if value["swiftPackageManagerEnabled"] is not False:
        raise ValueError("The isolated iOS build must use one CocoaPods Firebase graph.")
    if not expected.issubset(value["configs"]) or not value["linked"] or not value["embedded"]:
        raise ValueError("The real Xcode graph did not connect the tenant notification extension.")
    for key, bundle, product in [("runner", tenant["iosBundleId"], "Runner"), ("extension", tenant["extensionBundleId"], "NotificationServiceExtension")]:
        if {x["name"] for x in value[key]} != expected or any(x["bundle"] != bundle or x["team"] != tenant["developmentTeam"] or x["product"] != product for x in value[key]):
            raise ValueError("An actual Xcode tenant configuration uses a foreign bundle or signing team.")
    native = workspace / "Platforms/store_user_app/ios"
    if value["sdkResources"] != [str(native / "Runner/GoogleService-Info.plist")] or value["extensionSources"] != [str(native / "NotificationServiceExtension/NotificationService.swift")]:
        raise ValueError("The real native resource/source membership is incorrect.")
    if value["archiveConfiguration"] != "Release-tenant" or value["launchConfiguration"] != "Debug-tenant":
        raise ValueError("The generated scheme uses an incorrect configuration.")
    for mode in ["Debug", "Profile", "Release"]:
        config = native / ("Flutter/tenant" + mode + ".xcconfig")
        if "Pods-Runner." + mode.lower() + "-tenant.xcconfig" not in config.read_text():
            raise ValueError("The native configuration does not include its matching CocoaPods configuration.")
    if read_display_name(native) != tenant["displayName"]:
        raise ValueError("The display name was not preserved literally.")
    return {"nativeTargetsVerified": True, "schemeVerified": True, "firebaseResourceMembershipVerified": True}


def read_display_name(native):
    return mobile_ios.read_plist(native / "Runner/Info.plist")["CFBundleDisplayName"]


def cleanup_derived_data(workspace, base=None, root=ROOT):
    """Remove only this probe's Xcode cache, identified by its exact workspace metadata."""
    workspace = Path(workspace).absolute()
    try:
        relative = workspace.relative_to(root / ".local")
    except ValueError:
        raise ValueError("Xcode cleanup requires an owned iOS probe workspace.") from None
    if len(relative.parts) != 2 or not relative.parts[0].startswith("ios-probe-") or len(relative.parts[0]) != 42 or any(c not in "0123456789abcdef" for c in relative.parts[0][10:]) or relative.parts[1] != "workspace":
        raise ValueError("Xcode cleanup requires an owned iOS probe workspace.")
    base = Path(base) if base is not None else Path.home() / "Library/Developer/Xcode/DerivedData"
    if base.is_symlink():
        raise ValueError("Xcode cache root cannot be linked.")
    expected = str(workspace / "Platforms/store_user_app/ios/Runner.xcworkspace")
    removed = 0
    for candidate in base.glob("Runner-*"):
        info = candidate / "info.plist"
        if candidate.is_symlink() or not candidate.is_dir() or candidate.stat().st_uid != os.getuid() or info.is_symlink() or not info.is_file() or info.stat().st_size > 65536:
            continue
        try:
            metadata = plistlib.loads(info.read_bytes())
        except (OSError, ValueError):
            continue
        if isinstance(metadata, dict) and metadata.get("WorkspacePath") == expected:
            shutil.rmtree(candidate)
            removed += 1
    return removed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ruby", default="ruby")
    parser.add_argument("--flutter", default="flutter")
    parser.add_argument("--compile-unsigned", action="store_true")
    args = parser.parse_args()
    os.umask(0o077)
    parent = ROOT / ".local"; parent.mkdir(exist_ok=True)
    directory = parent / ("ios-probe-" + uuid.uuid4().hex); directory.mkdir(mode=0o700)
    workspace = directory / "workspace"
    original = common.source_hash(ROOT)
    try:
        manifest = fixture_inputs(directory / "inputs")
        workspace, tenant = mobile_ios.prepare(manifest, manifest.parent, workspace, "ABCDE12345", 7, args.ruby)
        result = dict(verify_project(workspace, tenant, args.ruby), sourceHash=tenant["sourceHash"], compiledIosApp=False,
                      signedIpaBuilt=False, distributed=False, symbolsUploaded=False)
        if args.compile_unsigned:
            with mobile_ios.private_log(directory / "fixture.log") as log:
                result.update(mobile_ios.compile_unsigned(workspace, tenant, args.flutter, log))
        if common.source_hash(ROOT) != original:
            raise ValueError("The probe changed the source checkout.")
        common.private_json(directory / "result.json", result)
        print(json.dumps({"diagnostics": str(directory), "result": result}))
        return 0
    finally:
        if workspace.is_dir() and not workspace.is_symlink():
            log = workspace / "ios-prepare.log"
            if log.is_file() and not log.is_symlink(): shutil.copyfile(log, directory / "prepare.log")
            shutil.rmtree(workspace)
        cleanup_derived_data(workspace)
        shutil.rmtree(directory / "inputs", ignore_errors=True)


if __name__ == "__main__":
    raise SystemExit(main())
