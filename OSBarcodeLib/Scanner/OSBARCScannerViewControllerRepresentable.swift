import AVFoundation
import SwiftUI

/// Structure responsible for bridging `OSBARCScannerViewController` into SwiftUI.
struct OSBARCScannerViewControllerRepresentable: UIViewControllerRepresentable {
    /// The camera used to capture video for barcode scanning.
    private let captureDevice: AVCaptureDevice?
    
    /// The object containing the value to return.
    @Binding private var scanResult: String
    
    /// Indicates if scanning should be done only after a button click or automatically.
    private let scanThroughButton: Bool
    /// Indicates if scanning is enabled (when there's a Scan Button).
    @Binding private var scanButtonEnabled: Bool
    
    /// Orientation the screen should adapt to.
    private let orientationModel: OSBARCOrientationModel
    
    /// Constructor method.
    /// - Parameters:
    ///   - captureDevice: The camera used to capture video for barcode scanning.
    ///   - scanResult: The object containing the value to return.
    ///   - scanThroughButton: Indicates if scanning should be done only after a button click or automatically.
    ///   - scanButtonEnabled: Indicates if scanning is enabled (when there's a Scan Button).
    ///   - orientationModel: Orientation the screen should adapt to.
    init(_ captureDevice: AVCaptureDevice?, _ scanResult: Binding<String>, _ scanThroughButton: Bool, _ scanButtonEnabled: Binding<Bool>, _ orientationModel: OSBARCOrientationModel) {
        self.captureDevice = captureDevice
        self._scanResult = scanResult
        self.scanThroughButton = scanThroughButton
        self._scanButtonEnabled = scanButtonEnabled
        self.orientationModel = orientationModel
    }
    
    func makeUIViewController(context: Context) -> OSBARCScannerViewController {
        .init(delegate: context.coordinator, captureDevice: captureDevice, orientationModel: orientationModel)
    }
    
    func updateUIViewController(_ uiViewController: OSBARCScannerViewController, context: Context) {
        // Required but nothing to do here.
    }
    
    func makeCoordinator() -> OSBARCScannerViewControllerCoordinator {
        Coordinator($scanResult, scanThroughButton, $scanButtonEnabled)
    }
}
