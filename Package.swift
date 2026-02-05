// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OSBarcodeLib",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "OSBarcodeLib",
            targets: ["OSBarcodeLib"]
        ),
    ],
    targets: [
        .target(
            name: "OSBarcodeLib",
            path: "Sources/OSBarcodeLib",
            resources: [
                .process("Scanner/OSBARCScannerView.xcassets")
            ]
        ),
        .testTarget(
            name: "OSBarcodeLibTests",
            dependencies: ["OSBarcodeLib"],
            path: "Tests/OSBarcodeLibTests"
        ),
    ]
)
