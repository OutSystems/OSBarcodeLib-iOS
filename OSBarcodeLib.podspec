Pod::Spec.new do |spec|
  spec.name                   = "OSBarcodeLib"
  spec.version                = "2.1.0"

  spec.summary                = "The OSBarcodeLib is a library built using Swift that offers you a barcode scanner for your iOS application."

  spec.homepage               = "https://github.com/OutSystems/OSBarcodeLib-iOS"
  spec.license                = { :type => 'MIT', :file => 'LICENSE' }
  spec.author                 = { 'OutSystems Mobile Ecosystem' => 'rd.mobileecosystem.team@outsystems.com' }

  spec.source                 = { :http => "https://github.com/OutSystems/OSBarcodeLib-iOS/releases/download/#{spec.version}/OSBarcodeLib.zip", :type => "zip" }
  spec.vendored_frameworks    = "OSBarcodeLib.xcframework"

  spec.ios.deployment_target  = '13.0'
  spec.swift_versions         = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9']
end