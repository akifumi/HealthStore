#
# Be sure to run `pod lib lint HealthStore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HealthStore'
  s.version          = '0.1.0'
  s.summary          = 'Wrapper for HealthKit to read and write data.'

  s.description      = <<-DESC
A simple wrapper for HealthKit to read and write data.
                       DESC

  s.homepage         = 'https://github.com/akifumi/HealthStore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'akifumi' => 'akifumi.fukaya@gmail.com' }
  s.source           = { :git => 'https://github.com/akifumi/HealthStore.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'HealthStore/Classes/**/*'
  s.frameworks = 'HealthKit'
end
