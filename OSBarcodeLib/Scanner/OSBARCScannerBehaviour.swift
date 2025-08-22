import AVFoundation
import Combine
import SwiftUI

/// Class responsible for the barcode scanner view flow.
final class OSBARCScannerBehaviour: OSBARCCoordinatable, OSBARCScannerProtocol {
    /// A publisher value responsible for the resulting scanned value.
    @Published private var scanResult: String = ""
    
    /// The publisher's cancellable instance collector.
    private var cancellables: Set<AnyCancellable> = []
    
    func startScanning(
        with instructionsText: String,
        _ buttonText: String?,
        _ cameraModel: OSBARCCameraModel,
        and orientationModel: OSBARCOrientationModel,
        andHint hint: OSBARCScannerHint?,
        _ completion: @escaping (String) -> Void
    ) {
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
        
        let buttonText = buttonText ?? ""   // not having the button enabled is translated into having an empty text.
        let shouldShowButton = !buttonText.isEmpty  // if empty text is passed, the button is not enabled on the scanner view
        
        let barcodeDecoder = OSBARCCaptureOutputDecoder(
            scanResultBinding,
            shouldShowButton,
            andHint: hint
        )
        let captureSessionManager = OSBARCCaptureSessionManager(
            cameraModel, 
            orientationModel,
            barcodeDecoder
        )
        guard let viewModel: OSBARCScannerViewModel = try? .init(cameraManager: captureSessionManager) else { return completion("") }
        let scannerView = OSBARCScannerView(
            viewModel: viewModel,
            scanResult: scanResultBinding,
            instructionsText: instructionsText,
            buttonText: buttonText,
            shouldShowButton: shouldShowButton,
            deviceType: UIDevice.current.userInterfaceIdiom.deviceTypeModel
        )
        let hostingController = OSBARCScannerViewHostingController(rootView: scannerView, orientationModel)
        hostingController.modalPresentationStyle = .fullScreen
        
        self.coordinator.present(hostingController)
    }
}
