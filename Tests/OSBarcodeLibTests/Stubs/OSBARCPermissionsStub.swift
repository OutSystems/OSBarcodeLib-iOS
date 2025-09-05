@testable import OSBarcodeLib

enum OSBARCPermissionsStubError: Error {
    case anError
}

final class OSBARCPermissionsStub: OSBARCPermissionsProtocol {
    var error: OSBARCPermissionsStubError?
    
    func hasCameraAccess() async -> Bool { error == nil }
}
