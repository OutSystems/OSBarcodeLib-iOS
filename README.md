# OSBarcodeLib

The `OSBarcodePluginLib-iOS` is a library built using `Swift` that offers you a barcode scanner for your iOS application. Supports many popular encoding types of 1D and 2D barcodes, such as:
- 1D Barcodes
	- Codabar (*available from iOS 15.0 onwards*)
	- Code 39
	- Code 93
	- Code 128
	- Databar (GS1)	(*available from iOS 15.0 onwards*)
	- EAN-8
	- EAN-13
	- ITF
	- ITF-14
	- ISBN-10
	- ISBN-13
	- ISBN-13 Dual Barcode
	- RSSExpanded (*available from iOS 15.0 onwards*)
	- UPC-A
	- UPC-E
- 2D Barcodes
	- Aztec Code
	- Data Matrix
	- Micro PDF 417 (*available from iOS 15.0 onwards*)
	- Micro QR (*available from iOS 15.0 onwards*)
	- PDF 417
	- QR Code

The `OSBARCManagerProtocol` protocol provides the main feature of the library, which is the **Barcode Scanner**, to be detailed in the following sections. 
The `OSBARCManagerFactory` provides a way to create the Scanner Flow Manager - the `OSBARCManager` that implements the `OSBARCManagerProtocol` protocol.

## Index

- [Motivation](#motivation)
- [Usage](#usage)
- [Methods](#methods)
    - [Scan Barcode](#scan-barcode)

## Motivation

This library is to be used by the [Barcode Plugin](https://github.com/OutSystems/cordova-outsystems-barcode). The repository contains a `scripts/build_framework.sh` script that allows the creation of the `OSBarcodeLib.xcframework`. This framework should then be imported into the Cordova bridge as a framework.

## Usage

The library is available on CocoaPods as `OSBarcodeLib`. The following is an example of how to insert it into a Cordova plugin (through the `plugin.xml` file).

```xml
<podspec>
    <config>
        <source url="https://cdn.cocoapods.org/"/>
    </config>
    <pods use-frameworks="true">
        ...
        <pod name="OSBarcodeLib" spec="${version to use}" />
        ...
    </pods>
</podspec>
```

It can also be included as a dependency on other podspecs.

```ruby
Pod::Spec.new do |s|
  ...
  s.dependency 'OSBarcodeLib', '${version to use}'
  ...
end
```

## Methods

The library uses the following method to interact with:

### Scan Barcode

```swift
func scanBarcode(with parameters: OSBARCScanParameters) async throws -> OSBARCScanResult
```

Triggers the barcode scanner, returning asynchronously, if successful, the scanned value. In case of error, it can throw one of the following:
- **cameraAccessDenied**: if camera access has not been given.
- **scanningCancelled**: If scanning has been cancelled by the end-user. 

The method is composed of the following input parameters, contained inside `OSBARCScanParameters` structure:
- **scanInstructions**: The text to be displayed on the scanning reader view.
- **scanButtonText**: The text to be displayed for the scan button, if configured. `Nil` value means that the button will not be shown.
- **cameraDirection**: Indicates the camera to use to gather input. It can be `back` or `front`.
- **scanOrientation**: Indicates the scanning reader view orientation. It can be locked to `portrait` or `landscape` or adapted to the device's current orientation if the value is `adaptive`.
- **hint**: Indicates scan of a specific format (e.g. only qr code). `Nil` or `unknown` value means it can scan all.

The method returns a `OSBARCScanResult structure`, containing:
- **text**: The actual textual data that was scanned.
- **format**: The format that was scanned, or `unknown` if unable to determine.
