import Foundation

/// All errors related with the `OSBARCManager` structure.
public enum OSBARCManagerError: Error {
    case cameraAccessDenied
    case scanningCancelled
}

/// Structure responsible for managing all barcode scanning flow.
struct OSBARCManager {
    /// Responsible for verifying the device's authorisation to its camera. It also handles the required flow to enable this authorisation.
    private let permissionsBehaviour: OSBARCPermissionsProtocol
    /// Responsible for triggering the barcode scanner view.
    private let scannerBehaviour: OSBARCScannerProtocol
    
    /// Constructor.
    /// - Parameters:
    ///   - permissionsBehaviour: Responsible for verifying the device's authorisation to its camera. It also handles the required flow to enable this authorisation.
    ///   - scannerBehaviour: Responsible for triggering the barcode scanner view.
    init(permissionsBehaviour: OSBARCPermissionsProtocol, scannerBehaviour: OSBARCScannerProtocol) {
        self.permissionsBehaviour = permissionsBehaviour
        self.scannerBehaviour = scannerBehaviour
    }
    
    /// Convenience constructor
    /// - Parameter coordinator: Object responsible for managing the screen flow, in response to the user's interaction.
    init(coordinator: OSBARCCoordinatorProtocol) {
        let permissionsBehaviour = OSBARCPermissionsBehaviour(coordinator: coordinator)
        let scannerBehaviour = OSBARCScannerBehaviour(coordinator: coordinator)
        self.init(permissionsBehaviour: permissionsBehaviour, scannerBehaviour: scannerBehaviour)
    }
}

/// Implementation of the `OSBARCManagerProtocol` methods.
extension OSBARCManager: OSBARCManagerProtocol {
    func scanBarcode(
        with parameters: OSBARCScanParameters
    ) async throws -> OSBARCScanResult {
        // validates if the user has access to the device's camera.
        let hasCameraAccess = await self.permissionsBehaviour.hasCameraAccess()
        if !hasCameraAccess { throw OSBARCManagerError.cameraAccessDenied }
        // requests the scanner to start, treating its result value.
        return try await withCheckedThrowingContinuation {
            self.startScanning(with: parameters, continuation: $0)
        }
    }
    
    /// Triggers the scanner view.
    /// - Parameters:
    ///   - parameters: The full parameter list to configure the scanner
    ///   - continuation: Object responsible for returning the method's result to its caller.
    private func startScanning(
        with parameters: OSBARCScanParameters,
        continuation: CheckedContinuation<OSBARCScanResult, any Error>
    ) {
        DispatchQueue.main.async {
            self.scannerBehaviour.startScanning(with: parameters) { scanResult in
                if !scanResult.text.isEmpty {
                    continuation.resume(returning: scanResult)
                } else {
                    continuation.resume(throwing: OSBARCManagerError.scanningCancelled)
                }
            }
        }
    }
}
