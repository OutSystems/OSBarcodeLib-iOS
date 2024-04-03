
Pod::Spec.new do |spec|
  spec.name = "OSBarcodeLib"
  spec.version = "0.0.1"
  spec.summary = "The OSBarcodeLib is a library built using Swift that offers you a barcode scanner for your iOS application."
  spec.homepage = "https://github.com/OutSystems/OSBarcodeLib-iOS"
  spec.license = "MIT"
  spec.author = "OutSystems"
  spec.ios.deployment_target  = '13.0'
  spec.swift_version = '5.1'
  spec.source = { :http => "https://github.com/IT-MikeS/OSBarcodeLib-iOS/releases/download/v#{spec.version}/OSBarcodeLib.zip", :type => "zip" }
  spec.vendored_frameworks = "OSBarcodeLib.xcframework"
end
