import AVFoundation
import SwiftUI

/// Structure responsible for bridging `OSBARCScannerViewController` into SwiftUI.
struct OSBARCScannerViewControllerRepresentable: UIViewControllerRepresentable {
    /// Object responsible for managing all things camera related.
    private let cameraManager: OSBARCCameraManager

    /// Constructor Method.
    /// - Parameter cameraManager: Object responsible for managing all things camera related.
    init(_ cameraManager: OSBARCCameraManager) {
        self.cameraManager = cameraManager
    }
    
    func makeUIViewController(context: Context) -> OSBARCScannerViewController {
        .init(cameraManager: cameraManager)
    }
    
    func updateUIViewController(_ uiViewController: OSBARCScannerViewController, context: Context) {
        // Required but nothing to do here.
    }
}
