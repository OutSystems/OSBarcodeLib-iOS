import AVFoundation
import SwiftUI
import Vision

/// Manages the sample buffers received from the video data output to return the desired information.
final class OSBARCScannerViewControllerCoordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    /// The object containing the value to return.
    @Binding private var scanResult: String
    /// Indicates if scanning should be done only  after a button click or automatically.
    private var scanThroughButton: Bool
    /// Indicates if scanning is enabled (when there's a Scan Button).
    @Binding private var scanButtonEnabled: Bool
    
    /// List of barcode types the scanner is looking for.
    lazy private var barcodeTypes: [VNBarcodeSymbology] = {
        var result: [VNBarcodeSymbology] = [.upce, .ean8, .ean13, .code39, .code93, .code128, .itf14, .qr, .dataMatrix, .pdf417, .aztec, .i2of5]
        if #available(iOS 15.0, *) {    // these types are only available from iOS 15 onwards.
            result += [.codabar, .gs1DataBar, .gs1DataBarExpanded, .microPDF417, .microQR]
        }
        return result
    }()
    
    /// Constructor.
    /// - Parameters:
    ///   - scanResult: Binding object with the value to return.
    ///   - scanThroughButton: Boolean indicating if scanning should be performed automatically or after clicking the Scan Button.
    ///   - scanButtonEnabled: Indicates if scanning has already been set on.
    init(_ scanResult: Binding<String>, _ scanThroughButton: Bool, _ scanButtonEnabled: Binding<Bool>) {
        self._scanResult = scanResult
        self.scanThroughButton = scanThroughButton
        self._scanButtonEnabled = scanButtonEnabled
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Output should only be processed when scanning is automatically or it has been enabled through the Scan Button.
        guard !self.scanThroughButton || scanButtonEnabled else { return }
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        var requestOptions: [VNImageOption: Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics: camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: requestOptions)
        try? imageRequestHandler.perform([self.detectBarcodeRequest])
    }
    
    /// Vision request to perform. It gets initialised only once and when needed.
    lazy private var detectBarcodeRequest: VNDetectBarcodesRequest = {
        .init(completionHandler: { request, error in
            guard error == nil else { return }
            self.processClassification(for: request)
        })
    }()
    
    /// Processes the Vision request to return the desired barcode value.
    /// - Parameter request: Vision request handler that performs image analysis.
    private func processClassification(for request: VNRequest) {
        DispatchQueue.main.async {
            if let bestResult = request.results?.first as? VNBarcodeObservation,
               let payload = bestResult.payloadStringValue,
               self.barcodeTypes.contains(bestResult.symbology) {
                self.scanResult = payload
            }
        }
    }
}
