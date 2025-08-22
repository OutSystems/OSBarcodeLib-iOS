/// Protocol that contains the main features of the scanner view.
protocol OSBARCScannerProtocol {
    /// Triggers the scanner view that allows the barcode scan.
    /// - Parameters:
    ///   - instructionsText: Text to be displayed on the scanner view.
    ///   - buttonText: Text to be displayed for the scan button, if this is configured. `Nil` value means that the button will not be shown.
    ///   - cameraModel: Camera to use for input gathering.
    ///   - orientationModel: Scanner view's orientation.
    ///   - hint: The optional hint, to scan a specific format (e.g. only qr code). `Nil` or `unknown` value means it can scan all.
    ///   - completion: The value returned or empty string in case the view is closed with no code scanned.
    func startScanning(
        with instructionsText: String,
        _ buttonText: String?,
        _ cameraModel: OSBARCCameraModel,
        and orientationModel: OSBARCOrientationModel,
        andHint hint: OSBARCScannerHint?,
        _ completion: @escaping (String) -> Void
    )
}
