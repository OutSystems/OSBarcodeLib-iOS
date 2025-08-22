@testable import OSBarcodeLib

final class OSBARCScannerStub: OSBARCScannerProtocol {
    var scanCancelled: Bool = false
    
    func startScanning(
        with parameters: OSBARCScanParameters,
        _ completion: @escaping (String) -> Void
    ) {
        completion(self.scanCancelled ? "" : OSBARCScannerStubValues.scannedCode)
    }
}
