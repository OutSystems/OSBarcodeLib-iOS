/// Errors related to the `OSBARCCameraManager`
enum OSBARCCameraManagerError: Error {
    case cameraNotConfigured(_: OSBARCCameraType)
}

/// Indicates the camera properties that can be retrieved and changed.
enum OSBARCCameraProperty {
    case zoomFactor
    case torch
}

/// Indicates the two types of cameras that can be used based on the selected zoom factor.
enum OSBARCCameraType {
    case regular
    case zoomOut
}
