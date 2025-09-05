import AVFoundation

extension OSBARCCameraType {
    /// Fetches the `AVCaptureDevice.DeviceType` equivalent values.
    var deviceType: AVCaptureDevice.DeviceType {
        switch self {
        case .regular: return .builtInWideAngleCamera
        case .zoomOut: return .builtInUltraWideCamera
        }
    }
}
