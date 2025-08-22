import AVFoundation
import Combine
import SwiftUI

/// Class responsible for the barcode scanner view flow.
final class OSBARCScannerBehaviour: OSBARCCoordinatable, OSBARCScannerProtocol {
    /// A publisher value responsible for the resulting scanned value.
    @Published private var scanResult: OSBARCScanResult = OSBARCScanResult.empty()
    
    /// The publisher's cancellable instance collector.
    private var cancellables: Set<AnyCancellable> = []
    
    func startScanning(
        with parameters: OSBARCScanParameters,
        _ completion: @escaping (OSBARCScanResult) -> Void
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
        
        let buttonText = parameters.scanButtonText ?? ""   // not having the button enabled is translated into having an empty text.
        let shouldShowButton = !buttonText.isEmpty  // if empty text is passed, the button is not enabled on the scanner view
        
        let barcodeDecoder = OSBARCCaptureOutputDecoder(
            scanResultBinding,
            shouldShowButton,
            andHint: parameters.hint
        )
        let captureSessionManager = OSBARCCaptureSessionManager(
            parameters.cameraDirection,
            parameters.scanOrientation,
            barcodeDecoder
        )
        guard let viewModel: OSBARCScannerViewModel = try? .init(cameraManager: captureSessionManager) else { return completion(OSBARCScanResult.empty()) }
        let scannerView = OSBARCScannerView(
            viewModel: viewModel,
            scanResult: scanResultBinding,
            instructionsText: parameters.scanInstructions,
            buttonText: buttonText,
            shouldShowButton: shouldShowButton,
            deviceType: UIDevice.current.userInterfaceIdiom.deviceTypeModel
        )
        let hostingController = OSBARCScannerViewHostingController(rootView: scannerView, parameters.scanOrientation)
        hostingController.modalPresentationStyle = .fullScreen
        
        self.coordinator.present(hostingController)
    }
}
