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

    /// Optional accessibility label for the cancel button. When `nil` or empty, no accessibility label is set.
    public let cancelButtonAccessibilityLabel: String?

    /// Optional accessibility label for the torch button when the torch is on. When `nil` or empty, no accessibility label is set.
    public let torchButtonOnAccessibilityLabel: String?

    /// Optional accessibility label for the torch button when the torch is off. When `nil` or empty, no accessibility label is set.
    public let torchButtonOffAccessibilityLabel: String?

    public init(scanInstructions: String,
                scanButtonText: String?,
                cameraDirection: OSBARCCameraModel,
                scanOrientation: OSBARCOrientationModel,
                hint: OSBARCScannerHint?,
                cancelButtonAccessibilityLabel: String? = nil,
                torchButtonOnAccessibilityLabel: String? = nil,
                torchButtonOffAccessibilityLabel: String? = nil) {
        self.scanInstructions = scanInstructions
        self.scanButtonText = scanButtonText
        self.cameraDirection = cameraDirection
        self.scanOrientation = scanOrientation
        self.hint = hint
        self.cancelButtonAccessibilityLabel = cancelButtonAccessibilityLabel
        self.torchButtonOnAccessibilityLabel = torchButtonOnAccessibilityLabel
        self.torchButtonOffAccessibilityLabel = torchButtonOffAccessibilityLabel
    }
}
