@testable import OSBarcodeLib

final class OSBARCScannerStub: OSBARCScannerProtocol {
    var scanCancelled: Bool = false
    
    func startScanning(with instructionsText: String, _ buttonText: String?, and cameraModel: OSBARCCameraModel, _ completion: @escaping (String) -> Void) {
        completion(self.scanCancelled ? "" : OSBARCScannerStubValues.scannedCode)
    }
}
