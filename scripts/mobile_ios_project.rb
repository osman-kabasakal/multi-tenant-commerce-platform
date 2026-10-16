# Configure only the isolated workspace selected by mobile_ios.py.
require 'json'
require 'yaml'
gem 'xcodeproj', '1.27.0'
require 'xcodeproj'

abort 'Expected isolated iOS path and tenant build metadata.' unless ARGV.length == 2
ios = File.expand_path(ARGV[0])
metadata = File.expand_path(ARGV[1])
workspace = File.dirname(metadata)
abort 'Unexpected iOS workspace.' unless ios == File.join(workspace, 'Platforms/store_user_app/ios') && File.basename(metadata) == 'ios-tenant-build.json'
tenant = JSON.parse(File.read(metadata))
team = tenant.fetch('developmentTeam')
bundle = tenant.fetch('iosBundleId')
abort 'Invalid native identity.' unless team.match?(/\A[A-Z0-9]{10}\z/) && bundle.match?(/\A[A-Za-z][A-Za-z0-9-]*(?:\.[A-Za-z][A-Za-z0-9-]*)+\z/) && tenant.fetch('extensionBundleId') == bundle + '.NotificationServiceExtension'
# The pinned plugins and Firebase extension share one CocoaPods dependency graph.
# Scope the Flutter override to this generated copy; never change user-wide config.
pubspec_path = File.join(ios, '../pubspec.yaml')
pubspec = YAML.safe_load(File.read(pubspec_path))
flutter = pubspec.fetch('flutter')
abort 'Unexpected Flutter configuration.' unless flutter.is_a?(Hash) && (!flutter.key?('config') || flutter['config'].is_a?(Hash))
flutter['config'] = (flutter['config'] || {}).merge('enable-swift-package-manager' => false)
File.write(pubspec_path, YAML.dump(pubspec))
project = Xcodeproj::Project.open(File.join(ios, 'Runner.xcodeproj'))
runner = project.targets.find { |target| target.name == 'Runner' }
abort 'Expected the tracked Runner target.' unless runner
copy = ->(value) { Marshal.load(Marshal.dump(value)) }

%w[Debug Profile Release].each do |mode|
  name = mode + '-tenant'
  type = mode == 'Debug' ? :debug : :release
  baseline = project.build_configurations.find { |config| config.name == mode }
  abort 'Missing base Xcode configuration.' unless baseline
  project.add_build_configuration(name, type).build_settings = copy.call(baseline.build_settings)
  project.targets.each do |target|
    base = target.build_configurations.find { |config| config.name == mode }
    next unless base
    config = target.add_build_configuration(name, type)
    config.build_settings = copy.call(base.build_settings)
    config.base_configuration_reference = nil
    config.build_settings['DEVELOPMENT_TEAM'] = team
    if target == runner
      relative = 'Flutter/tenant' + mode + '.xcconfig'
      contents = '#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.' + name.downcase + '.xcconfig"' + "\n" + '#include "Generated.xcconfig"' + "\n"
      File.write(File.join(ios, relative), contents)
      config.base_configuration_reference = project.main_group.new_file(relative)
      config.build_settings.merge!({
        'PRODUCT_BUNDLE_IDENTIFIER' => bundle,
        'PRODUCT_NAME' => 'Runner',
        'CODE_SIGN_STYLE' => 'Automatic',
        'CODE_SIGN_ENTITLEMENTS' => 'Runner/Runner.entitlements',
        'DEEP_LINK_HOST' => tenant.fetch('deepLinkHost'),
        'BUNDLE_NAME' => 'Runner',
        'BUNDLE_DISPLAY_NAME' => tenant.fetch('displayName'),
        'DEBUG_INFORMATION_FORMAT' => mode == 'Debug' ? 'dwarf' : 'dwarf-with-dsym'
      })
    else
      config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle + '.' + target.name
    end
  end
end

abort 'Unexpected existing extension target.' if project.targets.any? { |target| target.name == 'NotificationServiceExtension' }
extension = project.new_target(:app_extension, 'NotificationServiceExtension', :ios, '13.0')
group = project.main_group.new_group('NotificationServiceExtension', 'NotificationServiceExtension')
extension.source_build_phase.add_file_reference(group.new_file('NotificationService.swift'))
group.new_file('Info.plist')
extension.build_configurations.each do |config|
  config.build_settings.merge!({
    'PRODUCT_BUNDLE_IDENTIFIER' => tenant.fetch('extensionBundleId'),
    'PRODUCT_NAME' => 'NotificationServiceExtension',
    'PRODUCT_MODULE_NAME' => 'NotificationServiceExtension',
    'NOTIFICATION_EXTENSION_BUNDLE_ID' => tenant.fetch('extensionBundleId'),
    'DEVELOPMENT_TEAM' => team,
    'CODE_SIGN_STYLE' => 'Automatic',
    'INFOPLIST_FILE' => 'NotificationServiceExtension/Info.plist',
    'GENERATE_INFOPLIST_FILE' => 'NO',
    'SWIFT_VERSION' => '5.0',
    'APPLICATION_EXTENSION_API_ONLY' => 'YES',
    'SKIP_INSTALL' => 'YES',
    'FLUTTER_BUILD_NAME' => tenant.fetch('buildName'),
    'FLUTTER_BUILD_NUMBER' => tenant.fetch('buildNumber').to_s,
    'LD_RUNPATH_SEARCH_PATHS' => ['$(inherited)', '@executable_path/Frameworks', '@executable_path/../../Frameworks']
  })
end
runner.add_dependency(extension)
embed = runner.copy_files_build_phases.find { |phase| phase.name == 'Embed Foundation Extensions' } || runner.new_copy_files_build_phase('Embed App Extensions')
embed.dst_subfolder_spec = '13'
embed.add_file_reference(extension.product_reference, true).settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
# Flutter's embed/thin script reads the finished app bundle. Embed the extension
# first so Xcode does not form a cycle through Runner's processed Info.plist.
runner.build_phases.delete(embed)
thin_index = runner.build_phases.index { |phase| phase.respond_to?(:name) && phase.name == 'Thin Binary' }
abort 'Expected the tracked Flutter embed/thin phase.' unless thin_index
runner.build_phases.insert(thin_index, embed)
runner.resources_build_phase.add_file_reference(project.main_group.new_file('Runner/GoogleService-Info.plist'), true)
# CocoaPods regenerates its integration for the new configurations and target.
project.targets.each do |target|
  target.shell_script_build_phases.select { |phase| phase.name.to_s.start_with?('[CP]') }.each(&:remove_from_project)
end
project.save
scheme = Xcodeproj::XCScheme.new
scheme.add_build_target(runner)
scheme.set_launch_target(runner)
scheme.launch_action.build_configuration = 'Debug-tenant'
scheme.test_action.build_configuration = 'Debug-tenant'
scheme.analyze_action.build_configuration = 'Debug-tenant'
scheme.profile_action.build_configuration = 'Profile-tenant'
scheme.archive_action.build_configuration = 'Release-tenant'
scheme.save_as(project.path, 'tenant', true)

podfile = File.join(ios, 'Podfile')
contents = File.read(podfile)
anchor = "  'Release-demo' => :release,"
abort 'Unexpected tracked Podfile mapping.' unless contents.scan(anchor).length == 1
contents = contents.sub(anchor, anchor + "\n  'Debug-tenant' => :debug,\n  'Profile-tenant' => :release,\n  'Release-tenant' => :release,")
contents += "\ntarget 'NotificationServiceExtension' do\n  use_frameworks!\n  pod 'Firebase/Messaging'\nend\n"
File.write(podfile, contents)
puts 'Configured isolated tenant iOS targets and scheme; no signing or cloud API call.'
