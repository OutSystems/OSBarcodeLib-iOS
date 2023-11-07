import AVFoundation
import SwiftUI

/// Structure responsible for bridging `OSBARCScannerViewController` into SwiftUI.
struct OSBARCScannerViewControllerRepresentable: UIViewControllerRepresentable {
    /// The object containing the value to return.
    @Binding var result: String
    /// The camera used to capture video for barcode scanning.
    var captureDevice: AVCaptureDevice?
    
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
        Coordinator($result)
    }
}
