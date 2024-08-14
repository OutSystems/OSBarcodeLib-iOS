BUILD_FOLDER="build"
BUILD_SCHEME="OSBarcodeLib"
FRAMEWORK_NAME="OSBarcodeLib"
SIMULATOR_ARCHIVE_PATH="${BUILD_FOLDER}/iphonesimulator.xcarchive"
IOS_DEVICE_ARCHIVE_PATH="${BUILD_FOLDER}/iphoneos.xcarchive"

rm -rf "${FRAMEWORK_NAME}.zip"
rm -rf ${BUILD_FOLDER}

xcodebuild archive \
	-scheme ${BUILD_SCHEME} \
	-configuration Release \
	-destination 'generic/platform=iOS Simulator' \
	-archivePath "./${SIMULATOR_ARCHIVE_PATH}/" \
	SKIP_INSTALL=NO \
	BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
	-scheme ${BUILD_SCHEME} \
	-configuration Release \
	-destination 'generic/platform=iOS' \
	-archivePath "./${IOS_DEVICE_ARCHIVE_PATH}/" \
	SKIP_INSTALL=NO \
	BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
	-framework "./${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
		-debug-symbols "${PWD}/${SIMULATOR_ARCHIVE_PATH}/dSYMs/${FRAMEWORK_NAME}.framework.dSYM" \
	-framework "./${IOS_DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
		-debug-symbols "${PWD}/${IOS_DEVICE_ARCHIVE_PATH}/dSYMs/${FRAMEWORK_NAME}.framework.dSYM" \
	-output "./${BUILD_FOLDER}/${FRAMEWORK_NAME}.xcframework"

cp LICENSE ${BUILD_FOLDER}

cd "./${BUILD_FOLDER}"

zip -r "${FRAMEWORK_NAME}.zip" "${FRAMEWORK_NAME}.xcframework" LICENSE