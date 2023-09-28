# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'Vastar' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Vastar
    pod 'Alamofire' ,'4.9.1'
    pod 'IQKeyboardManagerSwift','6.5.6'
    pod 'SDWebImage', '~> 5.0'
    pod 'SwiftyRSA'
    pod 'CryptoSwift', '~> 1.4.1'
    pod 'HCVimeoVideoExtractor'
    pod 'GPVideoPlayer'
    pod 'BadgeHub'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
               end
          end
   end
end
