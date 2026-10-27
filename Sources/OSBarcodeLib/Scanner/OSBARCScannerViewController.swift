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

        self.geometryObservation?.invalidate()
        self.geometryObservation = nil

        self.cameraManager.stop()
    }
    
    /// Observes the window scene's geometry, so the preview follows rotations
    /// that don't trigger a transition or a new layout.
    private var geometryObservation: NSKeyValueObservation?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if #available(iOS 16.0, *), let windowScene = self.view.window?.windowScene {
            self.geometryObservation = windowScene.observe(\.effectiveGeometry) { [weak self] _, _ in
                DispatchQueue.main.async { self?.syncPreviewWithView() }
            }
        }
        self.syncPreviewWithView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Keeps the preview in sync with the view's size, including rotations that don't go through
        // `viewWillTransition(to:with:)`, such as the one requested when the scanner is presented
        // with a forced orientation.
        self.syncPreviewWithView()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let rotationToPerform: OSBARCCameraRotationChange = .init(value: (Int(size.height), Int(size.width)))
        try? self.cameraManager.apply(change: rotationToPerform)

        // The interface orientation only changes once the transition ends,
        // and a 180° rotation doesn't trigger a new layout.
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in self?.syncPreviewWithView() }
    }

    /// Resizes the camera preview to the view's bounds and aligns it with the current interface orientation.
    private func syncPreviewWithView() {
        let size = self.view.bounds.size
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        try? self.cameraManager.apply(change: OSBARCCameraRotationChange(value: (Int(size.height), Int(size.width))))
        CATransaction.commit()
    }
}
