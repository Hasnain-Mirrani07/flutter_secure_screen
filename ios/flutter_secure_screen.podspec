#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
# Run `pod lib lint flutter_secure_screen.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_secure_screen'
  s.version          = '1.0.0'
  s.summary          = 'Secure screen protection for fintech apps'
  s.description      = <<-DESC
  Secure screen protection for fintech apps. Disable screenshots, disable screen recording, and blur app when in background. Essential for banking, wallet, and password apps.
                       DESC
  s.homepage         = 'https://github.com/Hasnain-Mirrani07/flutter_secure_screen'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Name' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
