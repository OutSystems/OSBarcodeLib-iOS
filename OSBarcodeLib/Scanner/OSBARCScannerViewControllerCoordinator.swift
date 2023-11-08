import AVFoundation
import SwiftUI
import Vision

/// Manages the sample buffers received from the video data output to return the desired information.
final class OSBARCScannerViewControllerCoordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    /// The object containing the value to return.
    @Binding private var scanResult: String
    
    /// Constructor.
    /// - Parameter scanResult: Binding object with the value to return.
    init(_ scanResult: Binding<String>) {
        self._scanResult = scanResult
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
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
    
    /// List of barcode types the scanner is looking for.
    private var barcodeTypes: [VNBarcodeSymbology] {
        var result: [VNBarcodeSymbology] = [.upce, .ean8, .ean13, .code39, .code93, .code128, .itf14, .qr, .dataMatrix, .pdf417, .aztec, .i2of5]
        if #available(iOS 15.0, *) {    // these types are only available from iOS 15 onwards.
            result += [.codabar, .gs1DataBar, .gs1DataBarExpanded, .microPDF417, .microQR]
        }
        return result
    }
}
