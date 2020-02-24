require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "react-native-motion-manager"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/pwmckenna/react-native-motion-manager.git", :tag => "#{s.version}" }
  s.source_files  = "RNMotionManager/*.{h,m}"

  s.dependency 'React'
end
