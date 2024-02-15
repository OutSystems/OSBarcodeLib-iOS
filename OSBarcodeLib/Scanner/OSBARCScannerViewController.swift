import AVFoundation
import SwiftUI
import UIKit

/// Class responsible for displaying the camera stream that performs the scanning.
final class OSBARCScannerViewController: UIViewController {
    /// Object responsible for managing all things camera related.
    private let cameraManager: OSBARCCameraManager
    
    /// Constructor method.
    /// - Parameter cameraManager: Object responsible for managing all things camera related.
    init(cameraManager: OSBARCCameraManager) {
        self.cameraManager = cameraManager

        super.init(nibName: nil, bundle: nil)
    }
    
    /// Required method. This is not used.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let videoPreview = self.cameraManager.videoPreview {
            videoPreview.frame = view.layer.bounds
            view.layer.addSublayer(videoPreview)
            
            self.cameraManager.start()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cameraManager.stop()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let rotationToPerform: OSBARCCameraRotationChange = .init(value: (Int(size.height), Int(size.width)))
        try? self.cameraManager.apply(change: rotationToPerform)
    }
}
