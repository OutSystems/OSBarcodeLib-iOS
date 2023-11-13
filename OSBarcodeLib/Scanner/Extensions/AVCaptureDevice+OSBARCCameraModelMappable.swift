import AVFoundation

extension AVCaptureDevice.Position: OSBARCCameraModelMappable {
    static func map(_ value: OSBARCCameraModel) -> AVCaptureDevice.Position { value == .front ? .front : back }
}
