Pod::Spec.new do |s|
  s.name             = 'OSBarcodeLib'
  s.version          = '1.0.0'
  s.summary          = 'A summary'

  s.description      = 'A general description.'

  s.homepage         = 'https://github.com/OutSystems/OSBarcodeLib-iOS'
  s.license          = { :type => 'MIT', :file => 'docs/LICENSE' }
  s.author           = { 'Mobile Ecosystem Team' => 'rd.mobileecosystem.team@outsystems.com' }
  s.source           = { :git => 'https://github.com/OutSystems/OSBarcodeLib-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_versions = '5.0'

  s.vendored_frameworks = 'OSBarcodeLib.xcframework'
end