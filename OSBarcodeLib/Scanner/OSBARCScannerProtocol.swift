/// Protocol that contains the main features of the scanner view.
protocol OSBARCScannerProtocol {
    /// Triggers the scanner view that allows the barcode scan.
    /// - Parameter completion: The value returned or empty string in case the view is closed with no code scanned.
    func startScanning(_ completion: @escaping (String) -> Void)
}
