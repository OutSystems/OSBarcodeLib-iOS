/// Protocol that contains the main features of the library.
public protocol OSBARCManagerProtocol {
    /// Triggers the barcode scanner, returning, if possible, the scanned value.
    /// It can throw:
    ///     `cameraAccessDenied`: If camera access has not been given.
    ///     `scanningCancelled`: If scanning has been cancelled.
    /// - Parameters:
    ///   - instructionsText: Text to be displayed on the scanner view.
    ///   - buttonText: Text to be displayed for the scan button, if this is configured. `Nil` value means that the button will not be shown.
    ///   - cameraModel: Camera to use for input gathering.
    ///   - orientationModel: Scanner view's orientation.
    ///   - hint: The optional hint, to scan a specific format (e.g. only qr code). `Nil` or `unknown` value means it can scan all.
    /// - Returns: When successful, it returns the text associated with the scanned barcode.
    func scanBarcode(
        with instructionsText: String,
        _ buttonText: String?,
        _ cameraModel: OSBARCCameraModel,
        and orientationModel: OSBARCOrientationModel,
        andHint hint: OSBARCScannerHint?
    ) async throws -> String
}
