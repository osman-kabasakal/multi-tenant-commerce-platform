# Set manual signing only in the prepared tenant workspace; do not import keys/profiles.
require 'json'
gem 'xcodeproj', '1.27.0'
require 'xcodeproj'
abort 'Expected one prepared workspace.' unless ARGV.length == 1
workspace = File.expand_path(ARGV[0])
plan = JSON.parse(File.read(File.join(workspace, 'ios-signing-plan.json')))
tenant = JSON.parse(File.read(File.join(workspace, 'ios-tenant-build.json')))
abort 'Signing team does not match tenant preparation.' unless plan.fetch('developmentTeam') == tenant.fetch('developmentTeam') && plan.fetch('developmentTeam').match?(/\A[A-Z0-9]{10}\z/) && plan.fetch('certificateSha1').match?(/\A[0-9a-f]{40}\z/)
project = Xcodeproj::Project.open(File.join(workspace, 'Platforms/store_user_app/ios/Runner.xcodeproj'))
[['Runner', 'application', 'iosBundleId'], ['NotificationServiceExtension', 'extension', 'extensionBundleId']].each do |name, kind, expected|
  selected = plan.fetch(kind)
  abort 'Signing bundle does not match tenant preparation.' unless selected.fetch('bundle') == tenant.fetch(expected) && selected.fetch('uuid').match?(/\A[0-9A-Fa-f-]{36}\z/)
  target = project.targets.find { |value| value.name == name }
  config = target && target.build_configurations.find { |value| value.name == 'Release-tenant' }
  abort 'Missing prepared tenant release target.' unless config && config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] == selected.fetch('bundle')
  config.build_settings.merge!('CODE_SIGN_STYLE' => 'Manual', 'DEVELOPMENT_TEAM' => plan.fetch('developmentTeam'), 'CODE_SIGN_IDENTITY' => plan.fetch('certificateSha1'), 'PROVISIONING_PROFILE_SPECIFIER' => selected.fetch('uuid'))
  config.build_settings.delete('PROVISIONING_PROFILE')
end
project.save
puts 'Bound manual signing to the prepared tenant application and extension.'
