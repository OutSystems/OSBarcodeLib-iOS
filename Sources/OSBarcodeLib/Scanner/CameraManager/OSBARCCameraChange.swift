/// Protocol that is used to signal a modification on a camera property or setting.
protocol OSBARCCameraChange {
    associatedtype ValueType
    
    /// Property to apply the change to. If `nil` it indicates a change to the camera itself.
    var property: OSBARCCameraProperty? { get }
    /// The new value to apply.
    var value: ValueType { get set }
}

struct OSBARCCameraZoomFactorChange: OSBARCCameraChange {
    var property: OSBARCCameraProperty? { .zoomFactor }
    var value: Float
}

struct OSBARCCameraTorchChange: OSBARCCameraChange {
    var property: OSBARCCameraProperty? { .torch }
    var value: Bool
}

struct OSBARCCameraRotationChange: OSBARCCameraChange {
    var property: OSBARCCameraProperty? { nil }
    var value: (height: Int, width: Int)
}
