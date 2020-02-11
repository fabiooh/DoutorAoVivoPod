#
# Be sure to run `pod lib lint DoutorAoVivoPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DoutorAoVivoPod'
  s.version          = '0.0.1'
  s.summary          = 'Integracao com o consultorio da Doutor ao Vivo'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Como apoio ao desenvolvedor, a Doutor ao Vivo disponibiliza a sua sala de consultorio nativa.
                       DESC

  s.homepage         = 'https://www.doutoraovivo.com.br'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Fabio Ohtsuki' => 'fabioo@primeit.com.br' }
  s.source           = { :http => 'https://github.com/fabiooh/DoutorAoVivoPod/DoutorAoVivoPod.zip' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform          = :ios
  
  s.ios.deployment_target = '9.3'
  s.swift_version = '4.0'
  s.vendored_frameworks = 'DoutorAoVivo.framework'
  s.source_files = 'DoutorAoVivoPod/Classes/**/*'
  s.resources = 'DoutorAoVivoPod/Assets/*.xcassets'
  s.frameworks = 'UIKit' #, 'MapKit'
  s.static_framework = true
  s.dependency 'OpenTok'
  # s.dependency 'AFNetworking', '~> 2.3'
end
