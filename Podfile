# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'canadacitizenshipexam' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Define platform.
  platform :ios, '15.2'

  # Pods for canadacitizenshipexam
  pod 'Firebase/Core'
  pod 'FirebaseUI/Auth'
  pod 'FirebaseUI/Email'
  pod 'FirebaseUI/Google'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Functions'
  pod 'CardParts'

  target 'canadacitizenshipexamTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'canadacitizenshipexamUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'

      # Drop optimization for Swift pods in Debug to prevent frontend crashes
      if target.name == 'FirebaseAuth'
        target.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
            config.build_settings['SWIFT_COMPILATION_MODE'] = 'singlefile'
          end
        end
      end
      
      # Paste this specific block inside your existing post_install loop
      if target.name == 'BoringSSL-GRPC'
        target.source_build_phase.files.each do |file|
          if file.settings && file.settings['COMPILER_FLAGS']
            flags = file.settings['COMPILER_FLAGS'].split
            flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
            file.settings['COMPILER_FLAGS'] = flags.join(' ')
          end
        end
      end
    end
  end
end
