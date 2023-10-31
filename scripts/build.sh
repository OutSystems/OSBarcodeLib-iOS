cd ..

rm -rf build

xcodebuild archive \
-scheme LibTemplatePlaceholder \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './scripts/build/LibTemplatePlaceholder.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


xcodebuild archive \
-scheme LibTemplatePlaceholder \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './scripts/build/LibTemplatePlaceholder.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


xcodebuild -create-xcframework \
-framework './scripts/build/LibTemplatePlaceholder.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/LibTemplatePlaceholder.framework' \
-framework './scripts/build/LibTemplatePlaceholder.framework-iphoneos.xcarchive/Products/Library/Frameworks/LibTemplatePlaceholder.framework' \
-output './scripts/build/LibTemplatePlaceholder.xcframework'