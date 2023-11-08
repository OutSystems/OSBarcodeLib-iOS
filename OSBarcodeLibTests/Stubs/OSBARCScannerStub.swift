@testable import OSBarcodeLib

final class OSBARCScannerStub: OSBARCScannerProtocol {
    var scanCancelled: Bool = false
    
    func startScanning(_ completion: @escaping (String) -> Void) {
        completion(self.scanCancelled ? "" : OSBARCScannerStubValues.scannedCode)
    }
}
