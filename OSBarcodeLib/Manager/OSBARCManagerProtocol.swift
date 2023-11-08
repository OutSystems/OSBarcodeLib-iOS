/// Protocol that contains the main features of the library.
public protocol OSBARCManagerProtocol {
    /// Triggers the barcode scanner, returning, if possible, the scanned value.
    /// It can throw:
    ///     `cameraAccessDenied`: If camera access has not been given.
    ///     `scanningCancelled`: If scanning has been cancelled.
    /// - Parameter instructionsText: Text to be displayed on the scanner view.
    /// - Returns: When successful, it returns the text associated with the scanned barcode.
    func scanBarcode(with instructionsText: String) async throws -> String
}
