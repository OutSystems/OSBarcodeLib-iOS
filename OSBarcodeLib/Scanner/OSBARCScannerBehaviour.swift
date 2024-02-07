import AVFoundation
import Combine
import SwiftUI

/// Class responsible for the barcode scanner view flow.
final class OSBARCScannerBehaviour: OSBARCCoordinatable, OSBARCScannerProtocol {
    /// A publisher value responsible for the resulting scanned value.
    @Published private var scanResult: String = ""
    
    /// The publisher's cancellable instance collector.
    private var cancellables: Set<AnyCancellable> = []
    
    func startScanning(with instructionsText: String, _ buttonText: String?, _ cameraModel: OSBARCCameraModel, and orientationModel: OSBARCOrientationModel, _ completion: @escaping (String) -> Void) {
        $scanResult
            .dropFirst()    // drops the first value - the empty string
            .first()        // only publishes the first barcode value found
            .sink {
                self.coordinator.dismiss()
                completion($0)
            }
            .store(in: &cancellables)
        
        let scanResultBinding = Binding(    // binding object filled by the SwiftUI view
            get: {
                self.scanResult
            },
            set: {
                self.scanResult = $0
            }
        )

        // Get the default camera for capturing videos. This object will allows us to fetch the `hasTorch` method.
        let cameraToUse = AVCaptureDevice.Position.map(cameraModel)
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraToUse)
        let cameraHasTorch = captureDevice?.hasTorch ?? false
        let shouldShowZoomSelectorView: Bool
        
        var zoomFactorArray: [Float] = [1.0]
        if let captureDevice, Float(captureDevice.minAvailableVideoZoomFactor)...Float(captureDevice.maxAvailableVideoZoomFactor) ~= 2.0  {
            zoomFactorArray += [2.0]
            shouldShowZoomSelectorView = true
        } else {
            shouldShowZoomSelectorView = false
        }
        
        let buttonText = buttonText ?? ""   // not having the button enabled is translated into having an empty text.
        let scannerView = OSBARCScannerView(
            captureDevice: captureDevice,
            scanResult: scanResultBinding,
            cameraHasTorch: cameraHasTorch,
            instructionsText: instructionsText,
            buttonText: buttonText,
            shouldShowButton: !buttonText.isEmpty,  // if empty text is passed, the button is not enabled on the scanner view.
            zoomFactorArray: zoomFactorArray,
            shouldShowZoomSelectorView: shouldShowZoomSelectorView,
            orientationModel: orientationModel,
            deviceType: UIDevice.current.userInterfaceIdiom.deviceTypeModel
        )
        let hostingController = OSBARCScannerViewHostingController(rootView: scannerView, orientationModel)
        hostingController.modalPresentationStyle = .fullScreen
        
        self.coordinator.present(hostingController)
    }
}
