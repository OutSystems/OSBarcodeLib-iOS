/// Protocol that contains the main features of the scanner view.
protocol OSBARCScannerProtocol {
    /// Triggers the scanner view that allows the barcode scan.
    /// - Parameters:
    ///   - parameters: The full parameter list to configure the scanner
    ///   - completion: The value returned or empty string in case the view is closed with no code scanned.
    func startScanning(
        with parameters: OSBARCScanParameters,
        _ completion: @escaping (OSBARCScanResult) -> Void
    )
}
