public struct OSBARCScanParameters {
    /// Text to be displayed on the scanner view.
    public let scanInstructions: String
    
    /// Text to be displayed for the scan button, if this is configured. `Nil` value means that the button will not be shown.
    public let scanButtonText: String?
    
    // Camera to use for input gathering.
    public let cameraDirection: OSBARCCameraModel
    
    // Scanner view's orientation.
    public let scanOrientation: OSBARCOrientationModel
    
    // The optional hint, to scan a specific format (e.g. only qr code). `Nil` or `unknown` value means it can scan all.
    public let hint: OSBARCScannerHint?
    
    public init(scanInstructions: String,
                scanButtonText: String?,
                cameraDirection: OSBARCCameraModel,
                scanOrientation: OSBARCOrientationModel,
                hint: OSBARCScannerHint?) {
        self.scanInstructions = scanInstructions
        self.scanButtonText = scanButtonText
        self.cameraDirection = cameraDirection
        self.scanOrientation = scanOrientation
        self.hint = hint
    }
}
