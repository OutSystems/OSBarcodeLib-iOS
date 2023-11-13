/// Protocol that contains the main features of the scanner view.
protocol OSBARCScannerProtocol {
    /// Triggers the scanner view that allows the barcode scan.
    /// - Parameters:
    ///   - instructionsText: Text to be displayed on the scanner view.
    ///   - buttonText: Text to be displayed for the scan button, if this is configured. `Nil` value means that the button will not be shown.
    ///   - completion: The value returned or empty string in case the view is closed with no code scanned.
    ///   - cameraModel: Camera to use for input gathering.
    func startScanning(with instructionsText: String, _ buttonText: String?, and cameraModel: OSBARCCameraModel, _ completion: @escaping (String) -> Void)
}
