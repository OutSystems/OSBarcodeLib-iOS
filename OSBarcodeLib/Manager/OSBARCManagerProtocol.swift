/// Protocol that contains the main features of the library.
public protocol OSBARCManagerProtocol {
    /// Triggers the barcode scanner, returning, if possible, the scanned value.
    /// It can throw:
    ///     `cameraAccessDenied`: If camera access has not been given.
    ///     `scanningCancelled`: If scanning has been cancelled.
    /// - Parameters:
    ///   - parameters: The full parameter list to configure the scanner
    /// - Returns: When successful, it returns the text associated with the scanned barcode.
    func scanBarcode(
        with parameters: OSBARCScanParameters
    ) async throws -> String
}
