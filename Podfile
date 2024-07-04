# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'KTEvalutionTask' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KTEvalutionTask

pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'GoogleSignIn', '~> 5.0'
pod 'RealmSwift'
pod 'GoogleMaps'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    if config.name != 'Release'
      config.build_settings['VALID_ARCHS'] = 'arm64, arm64e, x86_64'
    end
  end
end


end
