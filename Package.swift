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
            path: "Sources/OSBarcodeLib"
        ),
        .testTarget(
            name: "OSBarcodeLibTests",
            dependencies: ["OSBarcodeLib"],
            path: "Tests/OSBarcodeLibTests"
        ),
    ]
)
