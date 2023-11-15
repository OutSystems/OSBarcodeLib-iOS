import AVFoundation

extension AVCaptureDevice.Position: OSBARCModelMappable {
    static func map(_ value: OSBARCCameraModel) -> AVCaptureDevice.Position { value == .front ? .front : back }
}
