#
# Be sure to run `pod lib lint maskedTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'maskedTextField'
  s.version          = '0.1.0'
  s.summary          = 'Delegate for UITextField to simplify work with masks'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  
  This pod includes a delegate for UITextField, which should helps you to make your text field more user-friendly. Also it provides you to get structured callbacks from your field. 
                       DESC

  s.homepage         = 'https://github.com/LedgerLeopard/maskedTFpod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iuriigushchin' => 'yurii.gushchin@ledgerleopard.com' }
  s.source           = { :git => 'https://github.com/LedgerLeopard/maskedTFpod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  

  s.ios.deployment_target = '9.0'

  s.source_files = 'maskedTextField/Classes/**/*'
  
  # s.resource_bundles = {
  #   'maskedTextField' => ['maskedTextField/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
