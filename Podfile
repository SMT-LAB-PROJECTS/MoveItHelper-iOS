# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'MoveIt' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inherit! :search_paths
  # Pods for MoveIt
  
  pod 'MBProgressHUD'
  
  pod 'Alamofire'
  pod 'AlamofireImage'
  
  pod 'JVFloatLabeledTextField'
  pod 'Toast-Swift'
  
  
  pod 'GooglePlaces'
  pod 'GoogleMaps'
  pod 'GoogleMLKit/SmartReply'
  
  pod 'Firebase/Auth'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/CoreOnly'
  pod 'Firebase/Messaging'
  
  pod 'CountryPickerView'
  pod 'IQKeyboardManagerSwift'
  
  pod 'Socket.IO-Client-Swift'
  
  pod 'Crashlytics'
  pod 'SwiftCharts'
  pod 'Charts'
  pod 'SkyFloatingLabelTextField'
  pod 'AccountKit'
  pod 'CCBottomRefreshControl'
  pod 'QCropper'
  pod 'Lightbox'
  pod 'SVPinView', '~> 1.0'
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
    end
  end
  #  target 'MoveItTests' do
  #    inherit! :search_paths
  #    # Pods for testing
  #  end
  #
  #  target 'MoveItUITests' do
  #    inherit! :search_paths
  #    # Pods for testing
  #  end
  
end

#post_install do |installer|
#    system("/bin/rm -rf Pods/AccountKit/AccountKitStrings.bundle/Resources/cb_IQ.lproj")
#    system("/bin/rm -rf Pods/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/cb_IQ.lproj")
#end
