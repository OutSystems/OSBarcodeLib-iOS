import AVFoundation
import SwiftUI

/// Structure responsible for bridging `OSBARCScannerViewController` into SwiftUI.
struct OSBARCScannerViewControllerRepresentable: UIViewControllerRepresentable {
    /// The camera used to capture video for barcode scanning.
    var captureDevice: AVCaptureDevice?
    
    /// The object containing the value to return.
    @Binding var scanResult: String
    
    /// Indicates if scanning should be done only after a button click or automatically.
    var scanThroughButton: Bool
    /// Indicates if scanning is enabled (when there's a Scan Button).
    @Binding var scanButtonEnabled: Bool
    
    /// Construtor method.
    /// - Parameters:
    ///   - captureDevice: The camera used to capture video for barcode scanning.
    ///   - scanResult: The object containing the value to return.
    ///   - scanThroughButton: Indicates if scanning should be done only after a button click or automatically.
    ///   - scanButtonEnabled: Indicates if scanning is enabled (when there's a Scan Button).
    init(_ captureDevice: AVCaptureDevice?, _ scanResult: Binding<String>, _ scanThroughButton: Bool, _ scanButtonEnabled: Binding<Bool>) {
        self.captureDevice = captureDevice
        self._scanResult = scanResult
        self.scanThroughButton = scanThroughButton
        self._scanButtonEnabled = scanButtonEnabled
    }
    
    func makeUIViewController(context: Context) -> OSBARCScannerViewController {
        let controller = OSBARCScannerViewController()
        controller.delegate = context.coordinator
        controller.captureDevice = captureDevice
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: OSBARCScannerViewController, context: Context) {
        // Required but nothing to do here.
    }
    func makeCoordinator() -> OSBARCScannerViewControllerCoordinator {
        Coordinator($scanResult, scanThroughButton, $scanButtonEnabled)
    }
}
