@testable import OSBarcodeLib

final class OSBARCScannerStub: OSBARCScannerProtocol {
    var scanCancelled: Bool = false
    
    func startScanning(
        with parameters: OSBARCScanParameters,
        _ completion: @escaping (OSBARCScanResult) -> Void
    ) {
        completion(self.scanCancelled ? OSBARCScanResult(text: "", format: .unknown) : OSBARCScannerStubValues.scannedCode)
    }
}
