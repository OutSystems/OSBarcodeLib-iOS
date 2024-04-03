rm -rf scripts/build
rm -rf OSBarcodeLib.xcframework

# cd ..

xcodebuild archive \
-scheme OSBarcodeLib \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './scripts/build/OSBarcodeLib.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


xcodebuild archive \
-scheme OSBarcodeLib \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './scripts/build/OSBarcodeLib.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


xcodebuild -create-xcframework \
-framework './scripts/build/OSBarcodeLib.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/OSBarcodeLib.framework' \
-framework './scripts/build/OSBarcodeLib.framework-iphoneos.xcarchive/Products/Library/Frameworks/OSBarcodeLib.framework' \
-output './OSBarcodeLib.xcframework'

zip -r ./scripts/build/OSBarcodeLib.zip ./OSBarcodeLib.xcframework